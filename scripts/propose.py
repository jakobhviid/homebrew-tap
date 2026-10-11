#!/usr/bin/env python3
"""Move each of a pipeline's casks to upstream's latest release, one at a time.

The propose half of every bump: for each cask it runs that cask's bump script
on its own, so a feed that cannot be read marks that cask broken and nothing
else. Casks that moved go forward to be tested; broken ones are reported; the
rest are already at upstream's latest. Craft's apps share a pins file and a
template, but `gen-craft-casks.py --bump <app>` moves one app's pin and
re-renders, so they bump one at a time too.

Writes `moved`, `broken` and `message` to $GITHUB_OUTPUT when it is set, and
prints them either way. `message` is `<token> <version>, ...`, the tap's commit
subject style.

Usage:
    scripts/propose.py github orca-linux
    scripts/propose.py proton proton-mail-linux proton-meet-linux proton-pass-linux
    scripts/propose.py craft photocraft-linux vectorcraft-linux ...
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = ROOT / "scripts"

# kind -> how to bump one cask. Each script exits non-zero when it cannot read
# upstream or cannot rewrite the cask, and leaves the files untouched then.
KINDS = {
    "github": lambda token: [SCRIPTS / "bump-cask.py", ROOT / "Casks" / f"{token}.rb"],
    "claude": lambda token: [SCRIPTS / "bump-claude.py", ROOT / "Casks" / f"{token}.rb"],
    "proton": lambda token: [SCRIPTS / "bump-proton.py", ROOT / "Casks" / f"{token}.rb"],
    "craft": lambda token: [SCRIPTS / "gen-craft-casks.py", "--bump", token.removesuffix("-linux")],
}


def version(token: str) -> str:
    text = (ROOT / "Casks" / f"{token}.rb").read_text(encoding="utf-8")
    m = re.search(r'^  version "([^"]+)"$', text, re.M)
    return m.group(1) if m else "?"


def changed(token: str) -> bool:
    diff = subprocess.run(
        ["git", "diff", "--quiet", "--", f"Casks/{token}.rb"], cwd=ROOT, check=False
    )
    return diff.returncode != 0


def main() -> None:
    if len(sys.argv) < 3 or sys.argv[1] not in KINDS:
        sys.exit(f"usage: {sys.argv[0]} {{{','.join(KINDS)}}} <token>...")
    kind, tokens = sys.argv[1], sys.argv[2:]

    moved, broken = [], []
    for token in tokens:
        print(f"::group::{token}", flush=True)
        result = subprocess.run([sys.executable, *map(str, KINDS[kind](token))], cwd=ROOT, check=False)
        print("::endgroup::", flush=True)
        if result.returncode != 0:
            print(f"::error::{token}: its bump script failed; the others carry on")
            broken.append(token)
        elif changed(token):
            moved.append(token)

    message = ", ".join(f"{t} {version(t)}" for t in moved)
    outputs = {"moved": " ".join(moved), "broken": " ".join(broken), "message": message}
    for key, value in outputs.items():
        print(f"{key}: {value or '-'}")
    if "GITHUB_OUTPUT" in os.environ:
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as out:
            for key, value in outputs.items():
                out.write(f"{key}={value}\n")


if __name__ == "__main__":
    main()
