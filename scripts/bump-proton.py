#!/usr/bin/env python3
"""Bump a Proton desktop cask to the latest Stable release.

A sibling to bump-cask.py rather than a generalisation of it: that script
resolves versions from GitHub's releases API, and Proton publishes no releases
there. The only official Linux channel is a direct .rpm from proton.me, resolved
through a per-app version.json — and those feeds are not uniform, which is the
whole reason this file exists rather than a shared one:

    mail   proton.me/download/mail/linux/version.json
    meet   proton.me/download/meet/linux/version.json
    pass   proton.me/download/PassDesktop/linux/x64/version.json   <- oddball

The URLs they hand back are inconsistent too. Mail and Meet put the version in
the path with a fixed filename ("ProtonMail-desktop-beta.rpm" on every channel,
Proton's delivery convention — the package metadata is proton-mail-X.Y.Z
regardless). Pass instead names the file after the package, including an RPM
release number that can move independently of the version.

Stable, not EarlyAccess, for all of them. The desktop updaters measure
themselves against the Stable feed whatever the webapp's Beta-access toggle
says, so an EarlyAccess build sits permanently "behind" and shows a standing
in-app update banner.

Prints the new version to stdout when it changed something and leaves the file
untouched otherwise, so a caller can branch on `git diff`.

Usage:
    scripts/bump-proton.py Casks/proton-mail-linux.rb
    scripts/bump-proton.py Casks/proton-pass-linux.rb --check   # report only
"""

from __future__ import annotations

import hashlib
import json
import re
import sys
import urllib.request
from pathlib import Path

# cask stem -> (version.json path, url template). The template is checked
# against what the feed actually returns, so a shape change upstream fails the
# run instead of silently pinning a URL that 404s.
APPS = {
    "proton-mail-linux": (
        "mail/linux",
        "https://proton.me/download/mail/linux/{version}/ProtonMail-desktop-beta.rpm",
    ),
    "proton-meet-linux": (
        "meet/linux",
        "https://proton.me/download/meet/linux/{version}/ProtonMeet-desktop.rpm",
    ),
    "proton-pass-linux": (
        "PassDesktop/linux/x64",
        "https://proton.me/download/pass/linux/proton-pass-{version}-1.x86_64.rpm",
    ),
}

VERSION_RE = re.compile(r'^(?P<pre>  version ")(?P<version>[^"]*)(?P<post>")$', re.MULTILINE)
# Arch-keyed, matching the casks: the key is what tells gen-readme.py (and a
# reader) that these are x86_64-only, so the rewriter has to expect it.
SHA_RE = re.compile(r'^(?P<pre>  sha256 x86_64_linux: ")(?P<sha>[0-9a-f]{64})(?P<post>")$', re.MULTILINE)


def get(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def latest_stable(feed_path: str) -> tuple[str, str]:
    """Return (version, rpm_url) for the newest Stable release in a feed."""
    feed = json.loads(get(f"https://proton.me/download/{feed_path}/version.json"))
    for release in feed.get("Releases", []):
        if release.get("CategoryName") != "Stable":
            continue
        for entry in release.get("File", []):
            url = entry.get("Url", "")
            if url.endswith(".rpm"):
                return release["Version"], url
    sys.exit(f"error: no Stable .rpm in the {feed_path} feed")


def sha256_of(url: str) -> str:
    """Stream the RPM through sha256 — they are ~100 MB and none is kept."""
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
    if cask.stem not in APPS:
        sys.exit(f"error: {cask.stem} is not a Proton cask this script knows")
    feed_path, url_template = APPS[cask.stem]

    src = cask.read_text(encoding="utf-8")
    match = VERSION_RE.search(src)
    if not match:
        sys.exit(f"error: no top-level `version` stanza in {cask}")
    current = match.group("version")

    latest, resolved_url = latest_stable(feed_path)

    # Why compare rather than trust: the cask interpolates its own URL from
    # `version`, so if Proton moves a filename or an RPM release number the cask
    # would build a URL the feed no longer serves. Failing here says which shape
    # changed; the alternative is a green bump whose download 404s for everyone.
    expected_url = url_template.format(version=latest)
    if expected_url != resolved_url:
        sys.exit(
            f"error: {cask.stem} URL shape changed upstream\n"
            f"  cask builds: {expected_url}\n"
            f"  feed serves: {resolved_url}\n"
            f"Update the url stanza and this script's template together."
        )

    if current == latest:
        print(f"{cask.stem} is up to date at {current}.")
        return
    print(f"{cask.stem}: {current} -> {latest}", file=sys.stderr)
    if check:
        sys.exit(f"{cask.stem} is behind: {current} -> {latest}")

    # Hash before rewriting, so a download failure leaves the cask untouched.
    sha = sha256_of(resolved_url)

    src = VERSION_RE.sub(lambda m: f"{m['pre']}{latest}{m['post']}", src, count=1)
    src, n = SHA_RE.subn(lambda m: f"{m['pre']}{sha}{m['post']}", src, count=1)
    if n != 1:
        sys.exit(f"error: could not rewrite the sha256 in {cask}")

    cask.write_text(src, encoding="utf-8")
    print(latest)


if __name__ == "__main__":
    main()
