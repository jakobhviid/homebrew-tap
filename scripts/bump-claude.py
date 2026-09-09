#!/usr/bin/env python3
"""Bump the Claude Desktop cask to the latest upstream release.

A sibling to bump-cask.py rather than a generalisation of it: that script takes
one version out of a tag, and this project's tag carries two. `aaddrick/
claude-desktop-debian` repackages Anthropic's client, so a release moves when
either side moves — the tag `v3.2.4+claude1.49585.0` pairs the packaging
revision with the Claude build, and both appear in the asset name:

    claude-desktop-unofficial-1.49585.0-3.2.4-1.x86_64.rpm

The cask keeps the pair as Homebrew's composite version, Claude's build first
(`version "1.49585.0,3.2.4"`), and interpolates its URL from both halves. So
this script has to split the tag and rejoin it in the cask's order, which is
where a shared implementation would stop being shared.

x86_64 only, matching the cask's `depends_on arch:`. Upstream publishes an
aarch64 RPM of every release; wanting it means a second cask, not a second hash
here — an arch-keyed sha256 leaves `brew audit` on the other runner with no hash
at all.

Prints the new version to stdout when it changed something and leaves the file
untouched otherwise, so a caller can branch on `git diff`.

Usage:
    scripts/bump-claude.py Casks/claude-desktop-linux.rb
    scripts/bump-claude.py Casks/claude-desktop-linux.rb --check   # report only
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import sys
import urllib.request
from pathlib import Path

REPO = "aaddrick/claude-desktop-debian"

# The tag's two halves, packaging revision first — the opposite of the cask's
# order, which is the whole reason this parse is explicit.
TAG_RE = re.compile(r"^v?(?P<packaging>\d+(?:\.\d+)+)\+claude(?P<claude>\d+(?:\.\d+)+)$")

# The one x86_64 RPM in a release. Matched loosely on purpose: the release
# number (`-1`) and the ordering of the two versions are upstream's to change,
# and the point is to find what upstream actually serves before comparing it
# with what the cask would build.
ASSET_RE = re.compile(r"^claude-desktop-unofficial-.*\.x86_64\.rpm$")

# What the cask's `url` stanza interpolates. Checked against the release's own
# asset URL, so a shape change upstream fails the run instead of silently
# pinning a URL that 404s. The `+` is percent-encoded, which is how GitHub
# serves it; an unencoded one is a different path.
URL_TEMPLATE = (
    f"https://github.com/{REPO}/releases/download/"
    "v{packaging}%2Bclaude{claude}/"
    "claude-desktop-unofficial-{claude}-{packaging}-1.x86_64.rpm"
)

VERSION_RE = re.compile(r'^(?P<pre>  version ")(?P<version>[^"]*)(?P<post>")$', re.MULTILINE)
SHA_RE = re.compile(r'^(?P<pre>  sha256 ")(?P<sha>[0-9a-f]{64})(?P<post>")$', re.MULTILINE)


def get(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    # A token lifts the 60/hour anonymous limit; the API call works without one.
    if token := os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN"):
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def latest_release() -> tuple[str, str, str]:
    """Return (cask_version, expected_url, served_url) for the newest release."""
    release = json.loads(get(f"https://api.github.com/repos/{REPO}/releases/latest"))

    tag = release.get("tag_name", "")
    match = TAG_RE.match(tag)
    if not match:
        sys.exit(
            f"error: {REPO}'s latest tag {tag!r} is not v<packaging>+claude<version>\n"
            "Update the cask's url stanza, its livecheck regex and this script's "
            "TAG_RE together."
        )
    claude, packaging = match["claude"], match["packaging"]

    served = [a for a in release.get("assets", []) if ASSET_RE.match(a.get("name", ""))]
    if len(served) != 1:
        names = ", ".join(sorted(a.get("name", "") for a in served)) or "none"
        sys.exit(f"error: expected exactly one x86_64 .rpm in {tag}, found: {names}")

    expected = URL_TEMPLATE.format(claude=claude, packaging=packaging)
    return f"{claude},{packaging}", expected, served[0]["browser_download_url"]


def sha256_of(url: str) -> str:
    """Stream the RPM through sha256 — it is ~176 MB and none of it is kept."""
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    digest = hashlib.sha256()
    with urllib.request.urlopen(request, timeout=900) as response:
        while chunk := response.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    check = "--check" in sys.argv[1:]
    if len(args) != 1:
        sys.exit(f"usage: {sys.argv[0]} <cask.rb> [--check]")

    cask = Path(args[0])
    src = cask.read_text(encoding="utf-8")

    match = VERSION_RE.search(src)
    if not match:
        sys.exit(f"error: no top-level `version` stanza in {cask}")
    current = match.group("version")

    latest, expected_url, served_url = latest_release()

    # Why compare rather than trust: the cask interpolates its own URL from
    # `version`, so if upstream moves the RPM release number, reorders the two
    # versions in the filename or stops encoding the `+`, the cask would build a
    # URL the release no longer serves. Failing here says which shape changed;
    # the alternative is a green bump whose download 404s for everyone.
    if expected_url != served_url:
        sys.exit(
            f"error: {cask.stem} URL shape changed upstream\n"
            f"  cask builds:   {expected_url}\n"
            f"  release serves: {served_url}\n"
            "Update the url stanza and this script's URL_TEMPLATE together."
        )

    if current == latest:
        print(f"{cask.stem} is up to date at {current}.")
        return
    print(f"{cask.stem}: {current} -> {latest}", file=sys.stderr)
    if check:
        sys.exit(f"{cask.stem} is behind: {current} -> {latest}")

    # Hash before rewriting, so a download failure leaves the cask untouched.
    sha = sha256_of(served_url)

    src = VERSION_RE.sub(lambda m: f"{m['pre']}{latest}{m['post']}", src, count=1)
    src, n = SHA_RE.subn(lambda m: f"{m['pre']}{sha}{m['post']}", src, count=1)
    if n != 1:
        sys.exit(f"error: could not rewrite the sha256 in {cask}")

    cask.write_text(src, encoding="utf-8")
    print(latest)


if __name__ == "__main__":
    main()
