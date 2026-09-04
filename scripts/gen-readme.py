#!/usr/bin/env python3
"""Regenerate the tool catalog table in README.md from Formula/*.rb and Casks/*.rb.

The formulae and casks are the single source of truth. This script mirrors each
one's `desc`, `homepage`, and platform support into the table between the
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
CASK_DIR = ROOT / "Casks"
README = ROOT / "README.md"

BEGIN = "<!-- BEGIN TOOLS (auto-generated from Formula/*.rb and Casks/*.rb — do not edit by hand) -->"
END = "<!-- END TOOLS -->"

# Platform arch guards used inside on_macos / on_linux blocks.
ARCH_LABELS = {"on_intel": "x86_64", "on_arm": "arm64"}
ARCH_ORDER = ["x86_64", "arm64"]

# Casks have no bottles, so their platform support is spelled out by the
# architecture-keyed `sha256` stanza instead of on_macos/on_linux blocks.
CASK_SHA_KEYS = {
    "arm": ("macOS", "arm64"),
    "intel": ("macOS", "x86_64"),
    "x86_64": ("macOS", "x86_64"),
    "arm64_linux": ("Linux", "arm64"),
    "x86_64_linux": ("Linux", "x86_64"),
}


def field(src: str, name: str) -> str | None:
    """First top-level `<name> "value"` string in the file (e.g. desc, homepage)."""
    m = re.search(rf'^\s*{name}\s+"([^"]*)"', src, re.MULTILINE)
    return m.group(1) if m else None


def summarize(oses: dict[str, set[str]]) -> str:
    """Render an {OS: {arch, ...}} map as a readable platform string."""
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


def platforms(src: str) -> str:
    """Platform summary for a formula, from its on_macos/on_linux + arch guards."""
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
    return summarize(oses)


def cask_platforms(src: str) -> str:
    """Platform summary for a cask, from its `sha256` keys narrowed by `depends_on`."""
    oses: dict[str, set[str]] = {}
    for key, (os_name, arch) in CASK_SHA_KEYS.items():
        # The keys after the first sit on continuation lines, so match either.
        if re.search(rf'^\s*(?:sha256\s+)?{key}:\s', src, re.MULTILINE):
            oses.setdefault(os_name, set()).add(arch)

    # A `depends_on :linux` / `depends_on macos:` gate is authoritative: it can
    # rule out an OS whose arch keys are present, and stands alone for a cask
    # whose sha256 is a single universal hash.
    def gated(pattern: str) -> bool:
        return re.search(rf"^\s*depends_on\s+{pattern}", src, re.MULTILINE) is not None

    for os_name, pattern in (("Linux", r"(?::linux\b|linux:)"), ("macOS", r"(?::macos\b|macos:)")):
        if gated(pattern):
            oses = {k: v for k, v in oses.items() if k == os_name} or {os_name: set()}
            break
    else:
        # No gate and no arch keys means an unrestricted single-hash cask, which
        # in practice is macOS-only — that's what a plain `cask` with an `app`
        # stanza is. Flag anything else so it can't be silently mislabelled.
        if not oses:
            return "—"

    return summarize(oses)


def cell(text: str) -> str:
    return text.replace("|", "\\|").strip()


def build_table() -> str:
    rows = ["| Tool | What it does | Platforms |", "| --- | --- | --- |"]
    entries = [(rb, platforms) for rb in FORMULA_DIR.glob("*.rb")]
    entries += [(rb, cask_platforms) for rb in CASK_DIR.glob("*.rb")]
    for rb, platform_fn in sorted(entries, key=lambda e: e[0].stem):
        src = rb.read_text(encoding="utf-8")
        name = rb.stem
        home = field(src, "homepage")
        label = f"[{name}]({home})" if home else f"`{name}`"
        rows.append(f"| {label} | {cell(field(src, 'desc') or '')} | {cell(platform_fn(src))} |")
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
        print("README.md is already in sync with the formulae and casks.")
        return
    if check:
        sys.exit("README.md is out of date — run scripts/gen-readme.py")
    README.write_text(updated, encoding="utf-8")
    print("README.md tool list updated.")


if __name__ == "__main__":
    main()
