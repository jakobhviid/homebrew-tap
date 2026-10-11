#!/usr/bin/env python3
"""Land what passed, report what did not, and clear the candidate branch.

The second half of every pipeline that changes the tap unattended — the cask
bumps and the formulae the tool repos push. A candidate commit has been tested;
this decides package by package what it may land:

* A package whose tests passed lands, even if another in the same candidate
  failed. One broken Craft app no longer holds back the other eleven.
* Landing copies the tested files onto the *current* main and commits, rather
  than fast-forwarding main to the candidate. Each package is its own file (plus
  its pin, for Craft), so this lands byte for byte what was tested, and two
  pipelines finishing at once retry instead of one failing on a moved main.
* Every package's outcome goes to scripts/report-ci.py, which keeps one issue
  open per broken package and closes it once the package passes.

Exits non-zero when anything failed, so the run shows red as well.

Reads its inputs from the environment (set by .github/workflows/_finish.yml):
PIPELINE, TOKENS, MOVED, BROKEN, SHA, CANDIDATE, SOURCE, PROPOSE_RESULT,
VALIDATE_RESULT, plus GH_TOKEN and the usual GITHUB_* variables.
"""

from __future__ import annotations

import importlib.util
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PINS = "scripts/craft-casks.json"

spec = importlib.util.spec_from_file_location("report_ci", ROOT / "scripts" / "report-ci.py")
report_ci = importlib.util.module_from_spec(spec)
spec.loader.exec_module(report_ci)


def git(*args: str, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(["git", *args], cwd=ROOT, check=check, capture_output=True, text=True)


def show(sha: str, path: str) -> str | None:
    result = git("show", f"{sha}:{path}", check=False)
    return result.stdout if result.returncode == 0 else None


def path_of(sha: str, name: str) -> str:
    return f"Casks/{name}.rb" if show(sha, f"Casks/{name}.rb") is not None else f"Formula/{name}.rb"


def failed_tests(moved: list[str]) -> list[str]:
    """The moved packages whose test jobs failed; all of them if unattributable.

    Each suite names its matrix jobs after the package first — `cask (pdfcraft,
    ...)`, `formula (temper, ...)` — so a failed job maps back to its package.
    A failed job that maps to none (a template check, a select job, orca's
    per-architecture jobs) leaves no way to tell, so every moved package fails.
    """
    found = set()
    for job in report_ci.run_jobs():
        if not job["name"].startswith("validate /") or job["conclusion"] != "failure":
            continue
        field = report_ci.job_subject(job["name"])
        name = next((t for t in moved if field in (t, t.removesuffix("-linux"))), None)
        if name is None:
            return moved
        found.add(name)
    return sorted(found) or moved


def apply(sha: str, names: list[str]) -> None:
    """Put each package's tested files into the working tree, on top of main."""
    pins = json.loads((ROOT / PINS).read_text(encoding="utf-8"))
    tested_pins = json.loads(show(sha, PINS) or "{}")
    touched_pins = False
    for name in names:
        git("checkout", sha, "--", path_of(sha, name))
        app = name.removesuffix("-linux")
        if app in tested_pins and app in pins and pins[app] != tested_pins[app]:
            # Main's order, this one app's tested pin: the other apps keep
            # whatever main has, which may be newer than the candidate's.
            pins[app] = tested_pins[app]
            touched_pins = True
    if touched_pins:
        (ROOT / PINS).write_text(json.dumps(pins, indent=2) + "\n", encoding="utf-8")
        # The landed casks must be exactly what the pins render to, or the
        # Craft suite fails main on its next push.
        subprocess.run([sys.executable, "scripts/gen-craft-casks.py", "--check"], cwd=ROOT, check=True)
    for name in names:
        path = path_of(sha, name)
        if git("diff", "--quiet", sha, "--", path, check=False).returncode != 0:
            sys.exit(f"error: {path} would land differently from what was tested")
    # A new package or a changed description must reach the catalog too; this
    # commit is made with the workflow token, which starts no other workflow.
    subprocess.run([sys.executable, "scripts/gen-readme.py"], cwd=ROOT, check=True)


def message(sha: str, names: list[str]) -> str:
    parts = []
    for name in names:
        m = re.search(r'^  version "([^"]+)"$', show(sha, path_of(sha, name)) or "", re.M)
        parts.append(f"{name} {m.group(1)}" if m else name)
    return ", ".join(parts)


def land(sha: str, names: list[str]) -> bool:
    """Commit the tested files onto main, retrying if main moves underneath."""
    author = git("log", "-1", "--format=%an <%ae>", sha).stdout.strip()
    git("config", "user.name", "github-actions[bot]")
    git("config", "user.email", "41898282+github-actions[bot]@users.noreply.github.com")
    for attempt in range(1, 6):
        git("fetch", "--quiet", "origin", "main")
        git("checkout", "--quiet", "--force", "-B", "land", "origin/main")
        apply(sha, names)
        git("add", "-A", "Casks", "Formula", PINS, "README.md")
        if git("diff", "--cached", "--quiet", check=False).returncode == 0:
            print("main already has these; nothing to land")
            return True
        # Keep the candidate's author, so a formula still reads as its tool's
        # release in the history; the committer says who landed it.
        git("commit", "--quiet", "--author", author, "-m", message(sha, names))
        if git("push", "--quiet", "origin", "HEAD:main", check=False).returncode == 0:
            print(f"landed on main: {message(sha, names)}")
            return True
        print(f"main moved while landing (attempt {attempt}); retrying")
    print("::error::could not land on main after 5 attempts")
    return False


def drop_candidate(branch: str, sha: str) -> None:
    # Only if it still points at what was tested: a newer push to it has its own
    # run coming, which must still find it.
    git("push", "--quiet", f"--force-with-lease=refs/heads/{branch}:{sha}", "origin", f":refs/heads/{branch}", check=False)


def main() -> None:
    env = os.environ
    pipeline = env["PIPELINE"]
    tokens, moved, broken = env["TOKENS"].split(), env.get("MOVED", "").split(), env.get("BROKEN", "").split()
    sha, candidate = env.get("SHA", ""), env.get("CANDIDATE", "")
    source = env.get("SOURCE", "bump")

    # A pipeline-level issue speaks for all its packages, so the freshness
    # check can tell their lag is already reported.
    covers = {pipeline: tokens} if pipeline not in tokens else {}

    if env["PROPOSE_RESULT"] != "success":
        # The propose job itself died, before it could say which package.
        failed = [pipeline] if env["PROPOSE_RESULT"] == "failure" else []
        report_ci.report(source, failed, [], covers=covers)
        sys.exit(1 if failed else 0)
    if sha:
        # The candidate lives on its own branch; this job checked out main.
        git("fetch", "--quiet", "origin", sha)

    failed, landed, held = list(broken), [], []
    validate = env.get("VALIDATE_RESULT", "skipped")
    if moved and validate in ("success", "failure"):
        bad = failed_tests(moved) if validate == "failure" else []
        passed = [t for t in moved if t not in bad]
        failed += bad
        if passed:
            if land(sha, passed):
                landed = passed
            else:
                failed += passed
    elif moved:
        # Validation was cancelled or never ran: nothing is known either way.
        held = moved
    if candidate and sha:
        drop_candidate(candidate, sha)

    # Healthy: what landed, and what never needed to move — it is at upstream's
    # latest on main. The pipeline key too, once its propose ran cleanly.
    healthy = [pipeline, *landed, *(t for t in tokens if t not in moved and t not in broken)]
    healthy = [k for k in healthy if k not in held]
    print(f"landed: {' '.join(landed) or '-'}; failed: {' '.join(failed) or '-'}; held: {' '.join(held) or '-'}")
    report_ci.report(source, failed, healthy, covers=covers)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
