#!/usr/bin/env python3
"""Keep one GitHub issue open per package that an unattended run finds broken.

The bumps, the weekly audit and the daily freshness check run with nobody
watching, and a red run is easy to miss — or, failing daily, easy to stop
seeing. This turns their outcome into issues instead: the first failure opens
one (`<key>: bump failing`, `<key>: audit failing`, `<key>: behind upstream`),
each later failure rewrites that issue's body (an edit notifies nobody, so a
package broken for a week costs one notification, not seven), and the next run
that finds the package healthy closes it. The open issues with the
`ci-failure` label are the whole list of what needs a human.

A key is a cask token wherever the failure can be pinned on one cask. Where it
cannot — Craft's and Proton's bump scripts stop at the first feed they cannot
read, before saying which — the key is the pipeline's own name, so the failure
is still reported once rather than not at all.

Usage (from a workflow job that `needs:` the jobs it reports on):
    scripts/report-ci.py bump  --pipeline orca-linux --tokens orca-linux
    scripts/report-ci.py bump  --pipeline "Proton casks" --tokens "proton-mail-linux ..."
    scripts/report-ci.py audit --pipeline tap --results-dir audit-results --legs 2
    scripts/report-ci.py freshness --livecheck livecheck.json \
        --state-in previous.json --state-out current.json [--dry-run]

`bump` reads the `needs` context from $NEEDS (`toJSON(needs)`); `audit` reads
the per-architecture failure lists the audit legs uploaded; `freshness` reads
`brew livecheck --json` output plus the list the previous run left behind. All
talk to GitHub through the `gh` CLI with $GH_TOKEN, except under --dry-run.
"""

from __future__ import annotations

import argparse
import datetime
import json
import os
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CASK_DIR = ROOT / "Casks"

LABEL = "ci-failure"
# State carried in the issue body, so a later run can say how long a package has
# been failing without anything stored outside the issue itself. `covers` lists
# the casks a pipeline-level issue speaks for, so the freshness check can tell
# that a cask's lag is already reported.
MARKER = re.compile(r"<!-- ci-failure first=(\S+) runs=(\d+)(?: covers=(\S+))? -->")

# source -> (title suffix, what the body calls the run). The bump and audit
# titles are matched against open issues, so changing one orphans those.
SOURCES = {
    "bump": ("bump failing", "bump"),
    "audit": ("audit failing", "audit"),
    "freshness": ("behind upstream", "freshness check"),
}


def gh(*args: str) -> str:
    return subprocess.run(["gh", *args], check=True, capture_output=True, text=True).stdout


def run_url() -> str:
    return (
        f"{os.environ['GITHUB_SERVER_URL']}/{os.environ['GITHUB_REPOSITORY']}"
        f"/actions/runs/{os.environ['GITHUB_RUN_ID']}"
    )


def failed_validate_tokens(tokens: list[str]) -> list[str] | None:
    """Pin a validation failure on the casks whose test jobs failed.

    Each install suite names its matrix jobs after the cask first — `cask
    (photocraft, ubuntu-latest)`, `cask (proton-mail-linux, ...)` — so a failed
    job maps back to its cask. Returns None when some failed job maps to no cask
    (a template check, the select job, orca's per-arch jobs), because then the
    caller cannot tell which of the casks it moved is at fault.
    """
    path = (
        f"repos/{os.environ['GITHUB_REPOSITORY']}/actions/runs/{os.environ['GITHUB_RUN_ID']}"
        f"/attempts/{os.environ.get('GITHUB_RUN_ATTEMPT', '1')}/jobs?per_page=100"
    )
    jobs = json.loads(gh("api", path))["jobs"]
    failed = [j["name"] for j in jobs if j["name"].startswith("validate /") and j["conclusion"] == "failure"]
    found = []
    for name in failed:
        m = re.search(r"\(([^,)]+)", name)
        field = m.group(1).strip() if m else ""
        token = next((t for t in tokens if field in (t, t.removesuffix("-linux"))), None)
        if token is None:
            return None
        found.append(token)
    return sorted(set(found)) or None


def judge_bump(pipeline: str, tokens: list[str], needs: dict) -> tuple[list[str], list[str]]:
    """Return (failed, healthy) keys for one run of a propose/validate/land bump."""
    propose = needs["propose"]
    if propose["result"] != "success":
        # The bump script itself failed, or was cancelled; a cancelled run says
        # nothing either way.
        return ([pipeline] if propose["result"] == "failure" else []), []

    outputs = propose.get("outputs", {})
    if outputs.get("bump") != "true":
        # Nothing moved, so main already holds upstream's latest — which is only
        # true once whatever broke an earlier candidate has been fixed.
        return [], [pipeline, *tokens]

    # A pipeline that bumps several casks says which moved; one that bumps a
    # single cask moved that cask.
    moved = outputs["tokens"].split() if "tokens" in outputs else tokens
    validate, land = needs["validate"]["result"], needs["land"]["result"]
    if validate == "success" and land == "success":
        return [], [pipeline, *tokens]
    if "cancelled" in (validate, land):
        return [], []

    # Casks that did not move are at upstream's latest on main regardless.
    healthy = [pipeline, *(t for t in tokens if t not in moved)]
    if validate == "failure":
        bad = failed_validate_tokens(moved) or moved
    else:
        # Validated but could not land, e.g. main moved under the candidate.
        bad = moved
    return (bad or [pipeline]), healthy


def judge_audit(pipeline: str, results_dir: Path, legs: int) -> tuple[list[str], list[str]]:
    """Return (failed, healthy) keys from the per-architecture audit results."""
    tokens = sorted(p.stem for p in CASK_DIR.glob("*.rb"))
    files = sorted(results_dir.glob("**/failed.txt")) if results_dir.exists() else []
    failed = sorted({t for f in files for t in f.read_text(encoding="utf-8").split()})
    if len(files) < legs:
        # A leg died before its loop wrote a result, so its casks were never
        # checked: report that, and vouch for no cask on the strength of it.
        return [pipeline, *failed], []
    return failed, [pipeline, *(t for t in tokens if t not in failed)]


def judge_freshness(
    livecheck: Path, state_in: Path, state_out: Path
) -> tuple[list[str], list[str], dict[str, str], dict[str, str]]:
    """Return (failed, healthy, details, unchecked) from one livecheck pass.

    A package counts as failed only when it was behind on the previous run too
    *and* its version here has not moved since. Behind once is normal: upstream
    can ship between a bump and this check, and scheduled runs fire hours late,
    so a bump can land after this check rather than before it. And a package
    that releases daily can be behind on every run while its pipeline works,
    moving one version each day. What marks a stuck pipeline is a package left
    behind on the same version. The first run has no previous state and only
    records.
    """
    behind, healthy, details, unchecked = [], [], {}, {}
    current: dict[str, str] = {}
    for entry in json.loads(livecheck.read_text(encoding="utf-8")):
        name = (entry.get("formula") or entry.get("cask") or "?").split("/")[-1]
        version = entry.get("version")
        if entry.get("status") in ("error", "skipped") or not version:
            unchecked[name] = "; ".join(entry.get("messages") or []) or entry.get("status", "no version")
        elif version.get("outdated"):
            behind.append(name)
            current[name] = str(version["current"])
            details[name] = f"The tap has {version['current']}; upstream is at {version['latest']}."
        else:
            healthy.append(name)

    # The state is each behind package's version here, keyed by package.
    previous = json.loads(state_in.read_text(encoding="utf-8")) if state_in.exists() else {}
    state_out.write_text(json.dumps(current, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    failed = [n for n in behind if previous.get(n) == current[n]]
    return failed, healthy, details, unchecked


def summarize(
    failed: list[str], healthy: list[str], behind: list[str],
    unchecked: dict[str, str], details: dict[str, str],
) -> None:
    """Write the freshness picture to the run's summary page."""
    total = len(healthy) + len(behind) + len(unchecked)
    lines = [
        "## Freshness", "",
        f"{total} packages: {len(healthy)} at upstream's latest, {len(behind)} behind, "
        f"{len(unchecked)} not checkable.", "",
    ]
    for name in behind:
        state = "stuck since the last run — reported" if name in failed else "waiting a run"
        lines.append(f"- **{name}**: {details[name]} ({state})")
    if healthy:
        lines += ["", f"At upstream's latest: {', '.join(sorted(healthy))}"]
    if unchecked:
        lines += ["", "Not checkable (no issue is opened for these):", ""]
        lines += [f"- **{name}**: {why}" for name, why in sorted(unchecked.items())]
    text = "\n".join(lines) + "\n"
    print(text)
    if "GITHUB_STEP_SUMMARY" in os.environ:
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a", encoding="utf-8") as out:
            out.write(text)


def open_issues() -> dict[str, dict]:
    issues = json.loads(
        gh("issue", "list", "--label", LABEL, "--state", "open", "--limit", "200",
           "--json", "number,title,body")
    )
    return {i["title"]: i for i in issues}


def body(
    key: str, source: str, first: str, runs: int, url: str, today: str,
    detail: str = "", covers: list[str] | None = None,
) -> str:
    times = "once" if runs == 1 else f"{runs} runs in a row"
    marker = f"first={first} runs={runs}" + (f" covers={','.join(covers)}" if covers else "")
    return (
        f"<!-- ci-failure {marker} -->\n"
        f"**{key}** has failed its unattended {SOURCES[source][1]} {times}, first on {first}.\n\n"
        + (f"{detail}\n\n" if detail else "")
        + f"Latest failing run: {url} ({today})\n\n"
        "Releases of every other package carry on. This issue updates itself on each "
        "failing run and closes on the next run that passes, so there is nothing to do "
        "here unless it stays open.\n"
    )


def report(
    source: str, failed: list[str], healthy: list[str],
    details: dict[str, str] | None = None, covers: dict[str, list[str]] | None = None,
) -> None:
    # A single-cask pipeline is keyed by its cask, so the same key can arrive
    # twice; a failure anywhere outranks a pass.
    failed = list(dict.fromkeys(failed))
    healthy = [k for k in dict.fromkeys(healthy) if k not in failed]
    url, today = run_url(), datetime.date.today().isoformat()
    existing = open_issues()
    details, covers = details or {}, covers or {}
    suffix = SOURCES[source][0]

    if source == "freshness":
        # A cask whose bump is already reported failing is behind for that
        # reason; a second issue would say the same thing twice.
        reported = set()
        for title, issue in existing.items():
            if title.endswith(f": {SOURCES['bump'][0]}"):
                reported.add(title.rsplit(": ", 1)[0])
                m = MARKER.search(issue["body"] or "")
                if m and m.group(3):
                    reported.update(m.group(3).split(","))
        for key in [k for k in failed if k in reported]:
            print(f"already reported by its bump: {key}")
        failed = [k for k in failed if k not in reported]

    if failed:
        # `--force` makes this idempotent, and creating it on demand means the
        # label needs no setup by hand in a fresh fork or after a deletion.
        gh("label", "create", LABEL, "--force", "--color", "B60205",
           "--description", "An unattended CI run is failing; closes itself when it passes")

    for key in failed:
        title = f"{key}: {suffix}"
        issue = existing.get(title)
        if issue is None:
            gh("issue", "create", "--title", title, "--label", LABEL,
               "--body", body(key, source, today, 1, url, today, details.get(key, ""), covers.get(key)))
            print(f"opened: {title}")
            continue
        m = MARKER.search(issue["body"] or "")
        first, runs = (m.group(1), int(m.group(2))) if m else (today, 0)
        gh("issue", "edit", str(issue["number"]),
           "--body", body(key, source, first, runs + 1, url, today, details.get(key, ""), covers.get(key)))
        print(f"updated #{issue['number']}: {title}")

    for key in healthy:
        title = f"{key}: {suffix}"
        issue = existing.get(title)
        if issue is not None:
            gh("issue", "close", str(issue["number"]), "--comment", f"Passed in {url}. Closing.")
            print(f"closed #{issue['number']}: {title}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("source", choices=list(SOURCES))
    parser.add_argument("--pipeline", help="bump/audit: key for failures no single cask owns")
    parser.add_argument("--tokens", default="", help="space-separated casks this bump covers")
    parser.add_argument("--results-dir", type=Path, default=Path("audit-results"))
    parser.add_argument("--legs", type=int, default=1, help="audit jobs expected to report")
    parser.add_argument("--livecheck", type=Path, help="`brew livecheck --json` output")
    parser.add_argument("--state-in", type=Path, help="packages the previous run found behind")
    parser.add_argument("--state-out", type=Path, help="where to record this run's")
    parser.add_argument("--dry-run", action="store_true", help="judge only; touch no issues")
    args = parser.parse_args()

    if args.source in ("bump", "audit") and not args.pipeline:
        parser.error(f"{args.source} needs --pipeline")

    details: dict[str, str] = {}
    covers: dict[str, list[str]] = {}
    if args.source == "bump":
        tokens = args.tokens.split()
        failed, healthy = judge_bump(args.pipeline, tokens, json.loads(os.environ["NEEDS"]))
        if args.pipeline not in tokens:
            covers[args.pipeline] = tokens
    elif args.source == "audit":
        failed, healthy = judge_audit(args.pipeline, args.results_dir, args.legs)
    else:
        if not (args.livecheck and args.state_in and args.state_out):
            parser.error("freshness needs --livecheck, --state-in and --state-out")
        failed, healthy, details, unchecked = judge_freshness(args.livecheck, args.state_in, args.state_out)
        summarize(failed, healthy, sorted(details), unchecked, details)
    print(f"failed: {' '.join(failed) or '-'}")
    if not args.dry_run:
        report(args.source, failed, healthy, details, covers)


if __name__ == "__main__":
    main()
