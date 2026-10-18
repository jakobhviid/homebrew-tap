#!/usr/bin/env python3
"""Bump a third-party formula to upstream's latest release, with its Linux bottle.

Most formulae here are rendered by their own tool's release pipeline. These are
the ones whose upstream is not ours: crw (github.com/us/crw) and the Proton
Drive CLI. Both ship prebuilt binaries, which the formulae install as they are,
but Homebrew on Linux wants a C compiler for any formula it cannot pour from a
bottle, and an atomic distro has none. So this also repackages upstream's
x86_64 Linux binary as a bottle — no compiling, just the keg layout brew would
have made — which the bump workflow publishes in this repo's releases, tagged
`<formula>-<version>`. macOS and arm64 Linux install upstream's binary directly.

This replaces the crw-brew and proton-drive-cli-brew repositories, which did
the same from outside the tap and pushed the result in with a deploy key.

Every upstream download is checked against the checksums upstream publishes —
crw's SHA256SUMS, Proton's per-file SHA-512 — before its SHA-256 goes into the
formula.

Leaves the formula untouched when it is at upstream's latest with its bottle
hosted here, so a caller can branch on `git diff`. Otherwise it rewrites the
formula and writes the bottle to build/bottles/.

Usage:
    scripts/bump-formula.py crw
    scripts/bump-formula.py proton-drive-cli
    scripts/bump-formula.py --publish crw proton-drive-cli   # release the built bottles
"""

from __future__ import annotations

import gzip
import hashlib
import io
import json
import os
import re
import subprocess
import sys
import tarfile
import time
import urllib.error
import urllib.request
from pathlib import Path
from string import Template

ROOT = Path(__file__).resolve().parent.parent
BOTTLES = ROOT / "build" / "bottles"
TAP_REPO = "jakobhviid/homebrew-tap"
RELEASES = f"https://github.com/{TAP_REPO}/releases/download"

PLATFORMS = ("mac_arm", "mac_x64", "lnx_arm", "lnx_x64")


def get(url: str) -> bytes:
    """GitHub's release CDN returns the odd 500; ride those out, not 4xx."""
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    # A token lifts the 60/hour anonymous limit; only the API needs it.
    if url.startswith("https://api.github.com/") and (token := os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")):
        request.add_header("Authorization", f"Bearer {token}")
    for attempt in range(4):
        try:
            with urllib.request.urlopen(request, timeout=300) as response:
                return response.read()
        except (urllib.error.URLError, TimeoutError, ConnectionError) as error:
            if isinstance(error, urllib.error.HTTPError) and error.code < 500 or attempt == 3:
                raise
            print(f"retrying after: {error}", file=sys.stderr)
            time.sleep(5 * 2**attempt)
    raise AssertionError("unreachable")


def checked_version(version: str, name: str) -> str:
    # The version is pasted into Ruby, file names, a release tag and a commit
    # message, so refuse anything that is not a plain version string.
    if not re.fullmatch(r"[0-9][0-9A-Za-z.+-]*", version):
        sys.exit(f"error: {name}: refusing unexpected upstream version {version!r}")
    return version


# --- upstreams -------------------------------------------------------------
#
# Each has two halves: `latest()` reads only the version, cheaply, so an
# up-to-date formula costs one request; `fetch(version)` downloads and verifies
# every platform's binary, and is only called when the formula has to move.


class Crw:
    name = "crw"
    binary = "crw"
    upstream = "us/crw"
    source = "upstream's GitHub releases"
    assets = {
        "mac_arm": "crw-darwin-arm64.tar.gz",
        "mac_x64": "crw-darwin-x64.tar.gz",
        "lnx_arm": "crw-linux-arm64.tar.gz",
        "lnx_x64": "crw-linux-x64.tar.gz",
    }

    def latest(self) -> str:
        release = json.loads(get(f"https://api.github.com/repos/{self.upstream}/releases/latest"))
        self.tag = release["tag_name"]
        return checked_version(self.tag.removeprefix("v"), self.name)

    def fetch(self, version: str) -> tuple[dict, bytes]:
        base = f"https://github.com/{self.upstream}/releases/download/{self.tag}"
        sums = {}
        for line in get(f"{base}/SHA256SUMS").decode().splitlines():
            if line.strip():
                sha, asset = line.split()
                sums[asset.lstrip("*")] = sha
        urls, linux_x64 = {}, b""
        for platform, asset in self.assets.items():
            if asset not in sums:
                sys.exit(f"error: crw {version}: {asset} missing from SHA256SUMS")
            print(f"  fetching {asset}", file=sys.stderr)
            data = get(f"{base}/{asset}")
            sha = hashlib.sha256(data).hexdigest()
            if sha != sums[asset]:
                sys.exit(f"error: crw {version}: {asset} does not match SHA256SUMS")
            urls[platform] = (f"{base}/{asset}", sha)
            if platform == "lnx_x64":
                with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as tar:
                    member = tar.extractfile("crw")
                    if member is None:
                        sys.exit(f"error: crw {version}: {asset} has no crw binary at its root")
                    linux_x64 = member.read()
        return urls, linux_x64

    template = r"""  desc "Turn URLs into clean markdown or JSON — scrape, crawl, search, MCP server"
  homepage "https://github.com/us/crw"
  version "${version}"
  # Upstream declares the deprecated bare "AGPL-3.0" and ships AGPLv3 with no
  # "or later" clause, which is SPDX "AGPL-3.0-only".
  license "AGPL-3.0-only"

${bottle}
  on_macos do
    on_arm do
      url "${url_mac_arm}"
      sha256 "${sha_mac_arm}"
    end
    on_intel do
      url "${url_mac_x64}"
      sha256 "${sha_mac_x64}"
    end
  end

  on_linux do
    on_arm do
      url "${url_lnx_arm}"
      sha256 "${sha_lnx_arm}"
    end
    on_intel do
      url "${url_lnx_x64}"
      sha256 "${sha_lnx_x64}"
    end
  end

  def install
    bin.install "crw"
  end

  def caveats
    <<~EOS
      crw runs fully locally — no account, no API key:

        crw example.com                 # page as markdown on stdout
        crw mcp                         # embedded MCP server for AI agents
        crw doctor                      # check renderer, search, proxy, ports

      When a page returns thin content, crw escalates to its own JS renderer and
      says so on stderr. Sites behind a Cloudflare challenge or DataDome return
      the interstitial rather than the article — clearing those needs a real
      browser session, not a renderer.

      `crw search` needs a backend: either a local one or the hosted CRW Cloud
      via `crw setup` (paid, with a free credit allowance). Scraping, crawling,
      mapping and the MCP server need none of it.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crw --version")
  end
"""


class ProtonDriveCli:
    name = "proton-drive-cli"
    binary = "proton-drive"
    manifest = "https://proton.me/download/drive/cli/version.json"
    source = "Proton's release manifest"
    platforms = {
        "mac_arm": "macos/arm64",
        "mac_x64": "macos/x64",
        "lnx_arm": "linux/arm64",
        "lnx_x64": "linux/x64",
    }

    def latest(self) -> str:
        feed = json.loads(get(self.manifest))
        stable = [r for r in feed.get("Releases", []) if r.get("CategoryName") == "Stable"]
        if not stable:
            sys.exit("error: proton-drive-cli: no Stable release in the manifest")
        self.release = stable[0]
        return checked_version(self.release["Version"], self.name)

    def fetch(self, version: str) -> tuple[dict, bytes]:
        files = {f.get("Platform"): f for f in self.release.get("Files", [])}
        urls, linux_x64 = {}, b""
        for platform, key in self.platforms.items():
            entry = files.get(key)
            if not entry or not entry.get("Url"):
                sys.exit(f"error: proton-drive-cli {version}: {key} missing from the manifest")
            print(f"  fetching {key}", file=sys.stderr)
            data = get(entry["Url"])
            if hashlib.sha512(data).hexdigest() != entry.get("Sha512CheckSum"):
                sys.exit(f"error: proton-drive-cli {version}: {key} does not match its SHA-512")
            urls[platform] = (entry["Url"], hashlib.sha256(data).hexdigest())
            if platform == "lnx_x64":
                linux_x64 = data
        return urls, linux_x64

    template = r"""  desc "Access Proton Drive end-to-end encrypted cloud storage from the terminal"
  homepage "https://proton.me/drive"
  version "${version}"
  license "MIT"

  # Proton publishes no tags these URLs could be checked against, so point
  # livecheck at the manifest this formula is generated from. Without it the
  # tap's daily freshness check cannot tell whether this formula has fallen
  # behind Proton.
  livecheck do
    url "https://proton.me/download/drive/cli/version.json"
    strategy :json do |json|
      json["Releases"]&.select { |r| r["CategoryName"] == "Stable" }&.map { |r| r["Version"] }
    end
  end

${bottle}
  on_macos do
    on_arm do
      url "${url_mac_arm}"
      sha256 "${sha_mac_arm}"
    end
    on_intel do
      url "${url_mac_x64}"
      sha256 "${sha_mac_x64}"
    end
  end

  on_linux do
    # On a headless Linux server there's no Secret Service/libsecret keyring, so
    # the session can be stored in `pass` instead (PROTON_DRIVE_CREDENTIALS_STORE
    # — see caveats). Ship it so that path is one env var away, not another install.
    depends_on "pass"

    on_arm do
      url "${url_lnx_arm}"
      sha256 "${sha_lnx_arm}"
    end
    on_intel do
      url "${url_lnx_x64}"
      sha256 "${sha_lnx_x64}"
    end
  end

  # Proton names the binary `proton-drive`; keep that so their docs' commands
  # work verbatim. The *formula* is proton-drive-cli to avoid the main app's name.
  def install
    bin.install "proton-drive"
  end

  def caveats
    <<~EOS
      proton-drive keeps its login session in your OS keyring — Keychain on macOS,
      Secret Service/libsecret on Linux. A headless Linux server has no keyring, so
      store the session in `pass` (installed as a dependency here) instead:

        gpg --quick-generate-key "proton-drive" default default never
        pass init "proton-drive"
        export PROTON_DRIVE_CREDENTIALS_STORE=pass   # add to your profile / systemd unit

      Sign-in is browser-based, so authenticate once interactively (or on a desktop
      sharing the same pass/GPG key) — then unattended cron/backup runs work.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proton-drive version")
  end
"""


FORMULAE = {f.name: f for f in (Crw, ProtonDriveCli)}

HEADER = """\
# Generated by scripts/bump-formula.py from {source} — edit
# that, not this file. The daily bump re-renders it when upstream moves.
class {cls} < Formula
"""

BOTTLE = """\
  # Prebuilt x86_64 Linux bottle so `brew install` pours it with no C compiler
  # (Homebrew-on-Linux otherwise requires one — a problem on atomic distros).
  # macOS and other arches fall back to upstream's url below; macOS always has
  # clang via the required Command Line Tools, so no bottle is needed.
  bottle do
    root_url "{root_url}"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "{sha}"
  end
"""


def formula_path(name: str) -> Path:
    return ROOT / "Formula" / f"{name}.rb"


def class_name(name: str) -> str:
    return "".join(part.capitalize() for part in name.split("-"))


def root_url(name: str, version: str) -> str:
    return f"{RELEASES}/{name}-{version}"


def bottle_path(name: str, version: str) -> Path:
    return BOTTLES / f"{name}-{version}.x86_64_linux.bottle.tar.gz"


def current(name: str) -> tuple[str | None, str | None]:
    """The version and bottle root_url the formula on disk pins."""
    path = formula_path(name)
    if not path.exists():
        return None, None
    text = path.read_text(encoding="utf-8")
    version = re.search(r'^  version "([^"]+)"$', text, re.M)
    root = re.search(r'^    root_url "([^"]+)"$', text, re.M)
    return (version and version.group(1)), (root and root.group(1))


def build_bottle(name: str, version: str, binary: str, data: bytes) -> str:
    """Write the keg brew would have installed, <name>/<version>/bin/<binary>.

    Fixed timestamps and owners make it reproducible: re-running a bump for the
    same version yields the same bytes, so a re-upload never strands a formula
    pinned to the previous upload's digest.
    """
    raw = io.BytesIO()
    with tarfile.open(fileobj=raw, mode="w", format=tarfile.PAX_FORMAT) as tar:
        for directory in (name, f"{name}/{version}", f"{name}/{version}/bin"):
            info = tarfile.TarInfo(directory)
            info.type, info.mode, info.mtime = tarfile.DIRTYPE, 0o755, 0
            tar.addfile(info)
        info = tarfile.TarInfo(f"{name}/{version}/bin/{binary}")
        info.size, info.mode, info.mtime = len(data), 0o755, 0
        tar.addfile(info, io.BytesIO(data))
    BOTTLES.mkdir(parents=True, exist_ok=True)
    path = bottle_path(name, version)
    with open(path, "wb") as out, gzip.GzipFile(fileobj=out, mode="wb", mtime=0, filename="") as gz:
        gz.write(raw.getvalue())
    return hashlib.sha256(path.read_bytes()).hexdigest()


def bump(name: str) -> None:
    upstream = FORMULAE[name]()
    version = upstream.latest()
    have_version, have_root = current(name)
    if have_version == version and have_root == root_url(name, version):
        print(f"{name}: already at {version}", file=sys.stderr)
        return
    print(f"{name}: {have_version} -> {version}", file=sys.stderr)

    urls, linux_x64 = upstream.fetch(version)
    if not linux_x64:
        sys.exit(f"error: {name} {version}: no x86_64 Linux binary to bottle")
    sha = build_bottle(name, version, upstream.binary, linux_x64)

    fields = {"version": version, "bottle": BOTTLE.format(root_url=root_url(name, version), sha=sha)}
    for platform in PLATFORMS:
        fields[f"url_{platform}"], fields[f"sha_{platform}"] = urls[platform]
    text = HEADER.format(source=upstream.source, cls=class_name(name))
    text += Template(upstream.template).substitute(fields) + "end\n"
    formula_path(name).write_text(text, encoding="utf-8")
    print(version)


def publish(names: list[str]) -> None:
    """Release each built bottle as `<name>-<version>` before its formula is tested.

    The candidate's tests pour the bottle from its root_url, so it has to
    resolve first. `--latest=false`: these are bottle stores, not releases of
    the tap, and must not take its "Latest" badge.
    """
    for name in names:
        version, _ = current(name)
        if version is None:
            sys.exit(f"error: no Formula/{name}.rb")
        path, tag = bottle_path(name, version), f"{name}-{version}"
        if not path.exists():
            sys.exit(f"error: {path} was not built; run the bump first")
        exists = subprocess.run(["gh", "release", "view", tag, "-R", TAP_REPO], capture_output=True).returncode == 0
        if exists:
            cmd = ["gh", "release", "upload", tag, str(path), "-R", TAP_REPO, "--clobber"]
        else:
            notes = (
                f"x86_64 Linux Homebrew bottle for {name} {version}, repackaged from upstream's "
                "release so `brew install` pours it without a compiler. Other platforms install "
                "from upstream directly."
            )
            cmd = ["gh", "release", "create", tag, str(path), "-R", TAP_REPO,
                   "--title", f"{name} {version}", "--notes", notes, "--latest=false"]
        subprocess.run(cmd, check=True)
        print(f"published {tag}", file=sys.stderr)


def main() -> None:
    args = sys.argv[1:]
    names = [a for a in args if not a.startswith("--")]
    unknown = [n for n in names if n not in FORMULAE]
    if not names or unknown:
        sys.exit(f"usage: {sys.argv[0]} [--publish] {{{','.join(FORMULAE)}}}...")
    if "--publish" in args:
        publish(names)
        return
    for name in names:
        bump(name)


if __name__ == "__main__":
    main()
