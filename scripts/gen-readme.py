#!/usr/bin/env python3
"""Regenerate the tool catalog table in README.md from Formula/*.rb.

The formulae are the single source of truth. This script mirrors each formula's
`desc`, `homepage`, and platform blocks into the table between the
`<!-- BEGIN TOOLS ... -->` and `<!-- END TOOLS -->` markers in README.md, so the
catalog can never drift out of sync with what the tap actually ships.

Usage:
    scripts/gen-readme.py           # rewrite README.md in place
    scripts/gen-readme.py --check   # exit non-zero if README.md is out of date
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FORMULA_DIR = ROOT / "Formula"
README = ROOT / "README.md"

BEGIN = "<!-- BEGIN TOOLS (auto-generated from Formula/*.rb — do not edit by hand) -->"
END = "<!-- END TOOLS -->"

# Platform arch guards used inside on_macos / on_linux blocks.
ARCH_LABELS = {"on_intel": "x86_64", "on_arm": "arm64"}
ARCH_ORDER = ["x86_64", "arm64"]


def field(src: str, name: str) -> str | None:
    """First top-level `<name> "value"` string in the formula (e.g. desc, homepage)."""
    m = re.search(rf'^\s*{name}\s+"([^"]*)"', src, re.MULTILINE)
    return m.group(1) if m else None


def platforms(src: str) -> str:
    """Readable platform summary from the on_macos/on_linux + arch guard blocks."""
    oses: dict[str, set[str]] = {}
    current: str | None = None
    for line in src.splitlines():
        s = line.strip()
        if s.startswith("on_macos"):
            current = "macOS"
            oses.setdefault(current, set())
        elif s.startswith("on_linux"):
            current = "Linux"
            oses.setdefault(current, set())
        elif current is not None:
            for token, label in ARCH_LABELS.items():
                if s.startswith(token):
                    oses[current].add(label)
    if not oses:
        return "—"

    def fmt(archs: set[str]) -> str:
        return ", ".join(sorted(archs, key=ARCH_ORDER.index))

    # If every OS supports the same arches, factor them out: "macOS, Linux (x86_64, arm64)".
    if len({frozenset(a) for a in oses.values()}) == 1:
        archs = next(iter(oses.values()))
        return ", ".join(oses) + (f" ({fmt(archs)})" if archs else "")
    # Otherwise annotate each OS with its own arches.
    return " · ".join(
        f"{os}{f' ({fmt(a)})' if a else ''}" for os, a in oses.items()
    )


def cell(text: str) -> str:
    return text.replace("|", "\\|").strip()


def build_table() -> str:
    rows = ["| Tool | What it does | Platforms |", "| --- | --- | --- |"]
    for rb in sorted(FORMULA_DIR.glob("*.rb")):
        src = rb.read_text(encoding="utf-8")
        name = rb.stem
        home = field(src, "homepage")
        label = f"[{name}]({home})" if home else f"`{name}`"
        rows.append(f"| {label} | {cell(field(src, 'desc') or '')} | {cell(platforms(src))} |")
    return "\n".join(rows)


def render(readme: str, table: str) -> str:
    pattern = re.compile(re.escape(BEGIN) + r".*?" + re.escape(END), re.DOTALL)
    if not pattern.search(readme):
        sys.exit(f"error: markers not found in {README}. Expected:\n{BEGIN}\n...\n{END}")
    return pattern.sub(lambda _: f"{BEGIN}\n{table}\n{END}", readme)


def main() -> None:
    check = "--check" in sys.argv[1:]
    readme = README.read_text(encoding="utf-8")
    updated = render(readme, build_table())
    if readme == updated:
        print("README.md is already in sync with the formulae.")
        return
    if check:
        sys.exit("README.md is out of date — run scripts/gen-readme.py")
    README.write_text(updated, encoding="utf-8")
    print("README.md tool list updated.")


if __name__ == "__main__":
    main()
