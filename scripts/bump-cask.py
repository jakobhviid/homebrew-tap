#!/usr/bin/env python3
"""Bump a GitHub-released cask to the latest upstream version.

Reads the cask's current `version`, asks GitHub for the newest release, and if
they differ rewrites `version` and every `sha256` in place. The hashes come from
the digests GitHub reports for release assets; an asset without one is streamed
straight into a hash, so nothing large is written to disk and the script is
cheap enough to run on a schedule.

At the same version, the hashes are compared with those digests too: a release
run again replaces its assets with rebuilt ones (a disk image signed again),
and the cask follows. A release that lacks one of the cask's assets leaves the
cask as it is, at the last release that has them all.

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
# line it belongs to. An asset name may carry `{version}`, filled with the new
# version. `None` means the cask carries a single bare `sha256 "..."`,
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
    "immich-mount": (
        "jakobhviid/immich-mount",
        # On macOS the notarized universal disk image, named with its version; on Linux the whole app (interfaces and
        # daemon), x86_64 only, in one archive named without one.
        {
            "arm": "immich-mount-{version}.dmg",
            "intel": "immich-mount-{version}.dmg",
            "x86_64_linux": "immich-mount-app-x86_64.tar.gz",
        },
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


def pinned_sha(src: str, key: str | None) -> str | None:
    """The hash the cask pins for one key, None when it has no such line."""
    match = sha_pattern(key).search(src)
    return match["sha"] if match else None


def get(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    # A token lifts the 60/hour anonymous limit; the API call works without one.
    if token := os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN"):
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def latest_release(repo: str) -> tuple[str, dict[str, str | None]]:
    """The newest release's version, and its assets by name with the sha256 GitHub reports (None where it has none)."""
    release = json.loads(get(f"https://api.github.com/repos/{repo}/releases/latest"))
    digests = {}
    for asset in release.get("assets", []):
        digest = asset.get("digest") or ""
        digests[asset["name"]] = digest.removeprefix("sha256:") if digest.startswith("sha256:") else None
    return release["tag_name"].lstrip("v"), digests


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

    latest, published = latest_release(repo)
    names = {key: asset.format(version=latest) for key, asset in assets.items()}
    missing = sorted({name for name in names.values() if name not in published})
    if missing:
        print(f"{cask.stem} stays at {current}: release {latest} lacks {', '.join(missing)}.", file=sys.stderr)
        return
    if current == latest:
        rebuilt = [key for key, name in names.items() if published[name] and published[name] != pinned_sha(src, key)]
        if not rebuilt:
            print(f"{cask.stem} is up to date at {current}.")
            return
        print(f"{cask.stem}: {current} was released again; new hashes for {', '.join(map(str, rebuilt))}", file=sys.stderr)
    else:
        print(f"{cask.stem}: {current} -> {latest}", file=sys.stderr)
    if check:
        sys.exit(f"{cask.stem} is behind: {current} -> {latest}")

    # Hash before rewriting, so a download failure leaves the cask untouched. An asset two keys share (one disk image
    # for both Mac architectures) is hashed once.
    by_name: dict[str, str] = {}
    shas = {}
    for key, name in names.items():
        if name not in by_name:
            by_name[name] = published[name] or asset_sha256(repo, latest, name)
        shas[key] = by_name[name]

    src = VERSION_RE.sub(lambda m: f"{m['pre']}{latest}{m['post']}", src, count=1)
    for key, sha in shas.items():
        src, n = sha_pattern(key).subn(lambda m, sha=sha: f"{m['pre']}{sha}{m['post']}", src, count=1)
        if n != 1:
            sys.exit(f"error: could not rewrite the {key or 'sha256'} hash in {cask}")

    cask.write_text(src, encoding="utf-8")
    print(latest)


if __name__ == "__main__":
    main()
