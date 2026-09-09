#!/usr/bin/env python3
"""Bump a GitHub-released cask to the latest upstream version.

Reads the cask's current `version`, asks GitHub for the newest release, and if
they differ rewrites `version` and every `sha256` in place. The assets are
streamed straight into a hash, so nothing large is written to disk and the
script is cheap enough to run on a schedule.

A sibling to bump-proton.py, which exists because Proton publishes no GitHub
releases at all. Everything reachable through the releases API belongs here
rather than in a per-app script: the only thing that differs between these casks
is which repo to ask and which assets its `sha256` stanza pins.

Prints the new version to stdout when it changed something and leaves the file
untouched otherwise, so a caller can branch on `git diff`.

Usage:
    scripts/bump-cask.py Casks/orca-linux.rb
    scripts/bump-cask.py Casks/paseo-linux.rb --check   # report only, no rewrite
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import sys
import urllib.request
from pathlib import Path

# cask stem -> (GitHub repo, {cask sha256 key: release asset name}).
#
# The asset map is keyed by the cask's own sha256 key so the rewrite can find the
# line it belongs to. `None` means the cask carries a single bare `sha256 "..."`,
# which is what a one-architecture cask has to use — arch-keying it would leave
# `brew audit` on the other architecture with no hash at all.
CASKS = {
    "orca-linux": (
        "stablyai/orca",
        {
            "arm64_linux": "orca-linux-arm64.AppImage",
            "x86_64_linux": "orca-linux.AppImage",
        },
    ),
    "paseo-linux": (
        "getpaseo/paseo",
        # Upstream names the Linux AppImage after the architecture only — no
        # version in the filename — so the release tag is the only part of the
        # URL that moves. There is no arm64 Linux asset to pin.
        {None: "Paseo-x86_64.AppImage"},
    ),
}

VERSION_RE = re.compile(r'^(?P<pre>  version ")(?P<version>[^"]*)(?P<post>")$', re.MULTILINE)


def sha_pattern(key: str | None) -> re.Pattern[str]:
    """The cask line holding one asset's hash: a keyed line, or the bare stanza."""
    if key is None:
        return re.compile(r'^(?P<pre>  sha256 ")(?P<sha>[0-9a-f]{64})(?P<post>")$', re.MULTILINE)
    # In a multi-architecture cask the keys after the first sit on continuation
    # lines, so `sha256 ` is optional here.
    return re.compile(
        rf'^(?P<pre>\s*(?:sha256 )?{key}:\s+")(?P<sha>[0-9a-f]{{64}})(?P<post>")', re.MULTILINE
    )


def get(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    # A token lifts the 60/hour anonymous limit; the API call works without one.
    if token := os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN"):
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def latest_version(repo: str) -> str:
    release = json.loads(get(f"https://api.github.com/repos/{repo}/releases/latest"))
    return release["tag_name"].lstrip("v")


def asset_sha256(repo: str, version: str, asset: str) -> str:
    """Stream the asset through sha256 without keeping 150 MB around."""
    url = f"https://github.com/{repo}/releases/download/v{version}/{asset}"
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    digest = hashlib.sha256()
    with urllib.request.urlopen(request, timeout=600) as response:
        while chunk := response.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    check = "--check" in sys.argv[1:]
    if len(args) != 1:
        sys.exit(f"usage: {sys.argv[0]} <cask.rb> [--check]")

    cask = Path(args[0])
    if cask.stem not in CASKS:
        sys.exit(f"error: {cask.stem} is not a GitHub-released cask this script knows")
    repo, assets = CASKS[cask.stem]

    src = cask.read_text(encoding="utf-8")

    match = VERSION_RE.search(src)
    if not match:
        sys.exit(f"error: no top-level `version` stanza in {cask}")
    current = match.group("version")

    latest = latest_version(repo)
    if current == latest:
        print(f"{cask.stem} is up to date at {current}.")
        return
    print(f"{cask.stem}: {current} -> {latest}", file=sys.stderr)
    if check:
        sys.exit(f"{cask.stem} is behind: {current} -> {latest}")

    # Hash before rewriting, so a download failure leaves the cask untouched.
    shas = {key: asset_sha256(repo, latest, asset) for key, asset in assets.items()}

    src = VERSION_RE.sub(lambda m: f"{m['pre']}{latest}{m['post']}", src, count=1)
    for key, sha in shas.items():
        src, n = sha_pattern(key).subn(lambda m, sha=sha: f"{m['pre']}{sha}{m['post']}", src, count=1)
        if n != 1:
            sys.exit(f"error: could not rewrite the {key or 'sha256'} hash in {cask}")

    cask.write_text(src, encoding="utf-8")
    print(latest)


if __name__ == "__main__":
    main()
