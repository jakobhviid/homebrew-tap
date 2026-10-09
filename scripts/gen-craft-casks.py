#!/usr/bin/env python3
"""Generate the ArtCraft "Crafting Apps" Linux casks from one template.

ArtCraft (github.com/storytold) ships a family of clean-room desktop apps —
PhotoCraft, PdfCraft, GridCraft and so on — that all come out of the same
release pipeline: identical asset names, an identical tarball layout, the same
desktop-integration files. Hand-keeping a dozen casks that differ only by name
would let them drift, so they are rendered from the template below instead.

Two inputs, split by who writes them:

  * APPS, below — the hand-edited part: display name, desc, homepage and the
    per-app data directories `zap` clears.
  * scripts/craft-casks.json — the machine-written part: the pinned version,
    both architectures' sha256, and the file manifest read out of that version's
    tarball (binaries, desktop entry, icons, MIME packages). Artifacts are
    generated from the manifest, so an upstream release that adds an icon size
    or a binary is picked up by the next bump rather than silently dropped.

Why the tarball and not the AppImage, .deb, .rpm or Flatpak upstream also ship:
it is already an FHS tree (bin/, share/applications, share/icons/hicolor,
share/mime), the binaries link nothing but glibc, and it carries no
self-integration — the AppImage's AppRun writes launcher files into
~/.local/share on first run that brew would never know to remove.

Usage:
    scripts/gen-craft-casks.py            # re-render Casks/*-linux.rb from the pins
    scripts/gen-craft-casks.py --check    # exit non-zero if a cask is out of date
    scripts/gen-craft-casks.py --bump     # move pins to upstream's latest, re-render
    scripts/gen-craft-casks.py --bump pdfcraft gridcraft   # ...for just these apps

`--bump` prints one `<token> <version>` line per cask it moved, so a caller can
build a commit message from stdout.
"""

from __future__ import annotations

import hashlib
import io
import json
import os
import re
import sys
import tarfile
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CASK_DIR = ROOT / "Casks"
PINS = ROOT / "scripts" / "craft-casks.json"

REPO_OWNER = "storytold"
# Upstream's arch spelling in asset names, keyed by the cask's sha256 key.
ARCHES = {"arm64_linux": "aarch64", "x86_64_linux": "x86_64"}

# Hand-edited per-app metadata. `desc` names the app each one is a clean-room
# reimplementation of, because that is what tells a reader of the tap's catalog
# what the thing *is*. The homepage is upstream's product page where one exists
# and the repository where it does not yet.
#
# `zap` lists only directories the app creates for itself, read out of each
# app's source: they disagree on config vs data dir (PdfCraft and FilmCraft keep
# everything under ~/.local/share, eframe-style), and the Linux spelling is
# lowercase even where macOS uses "Photocraft". Shared locations an app merely
# reads or defaults user content into — ~/.local/share/fonts, ~/.clap,
# ~/Pictures/LightCraft Library, ~/Documents/EffectCraft — are deliberately
# absent: zapping one would delete the user's own files. CADCraft writes no
# per-user state at all, so its cask has no zap stanza.
APPS: dict[str, dict] = {
    "photocraft": {
        "name": "PhotoCraft",
        "desc": "Photoshop-style image editor",
        "homepage": "https://getartcraft.com/apps/photocraft",
        "zap": ["~/.config/photocraft"],
    },
    "vectorcraft": {
        "name": "VectorCraft",
        "desc": "Illustrator-style vector graphics editor",
        "homepage": "https://getartcraft.com/apps/vectorcraft",
        "zap": ["~/.config/vectorcraft"],
    },
    "pdfcraft": {
        "name": "PdfCraft",
        "desc": "Acrobat-style PDF reader and editor",
        "homepage": "https://getartcraft.com/apps/pdfcraft",
        "zap": ["~/.local/share/pdfcraft"],
    },
    "lightcraft": {
        "name": "LightCraft",
        "desc": "Lightroom-style photo library and raw developer",
        "homepage": "https://getartcraft.com/apps/lightcraft",
        "zap": ["~/.config/lightcraft"],
    },
    "filmcraft": {
        "name": "FilmCraft",
        "desc": "Premiere-style video editor",
        "homepage": "https://getartcraft.com/apps/filmcraft",
        "zap": ["~/.local/share/filmcraft"],
    },
    "effectcraft": {
        "name": "EffectCraft",
        "desc": "After Effects-style motion graphics and VFX compositor",
        "homepage": "https://getartcraft.com/apps/effectcraft",
        "zap": ["~/.cache/effectcraft", "~/.config/effectcraft"],
    },
    "designcraft": {
        "name": "DesignCraft",
        "desc": "InDesign-style page layout and publishing app",
        "homepage": "https://getartcraft.com/apps/designcraft",
        "zap": ["~/.config/designcraft", "~/.local/share/designcraft"],
    },
    "wordcraft": {
        "name": "WordCraft",
        "desc": "Microsoft Word-style word processor",
        "homepage": "https://github.com/storytold/wordcraft",
        "zap": ["~/.config/wordcraft"],
    },
    "gridcraft": {
        "name": "GridCraft",
        "desc": "Microsoft Excel-style spreadsheet",
        "homepage": "https://github.com/storytold/gridcraft",
        "zap": ["~/.config/gridcraft"],
    },
    "deckcraft": {
        "name": "DeckCraft",
        "desc": "Microsoft PowerPoint-style presentation app",
        "homepage": "https://github.com/storytold/deckcraft",
        "zap": ["~/.config/deckcraft", "~/.local/share/deckcraft"],
    },
    "cadcraft": {
        "name": "CADCraft",
        "desc": "AutoCAD-style 2D drafting and design app",
        "homepage": "https://github.com/storytold/cadcraft",
        "zap": [],
    },
    "soundcraft": {
        "name": "SoundCraft",
        "desc": "Pro Tools-style digital audio workstation",
        "homepage": "https://github.com/storytold/soundcraft",
        "zap": ["~/.config/soundcraft"],
    },
}

TEMPLATE = '''\
# Generated by scripts/gen-craft-casks.py from scripts/craft-casks.json — edit
# those, not this file. CI re-renders every Craft cask and fails on any drift.
cask "{token}" do
  arch arm: "aarch64", intel: "x86_64"

  version "{version}"
  sha256 arm64_linux:  "{sha_arm64}",
         x86_64_linux: "{sha_x86_64}"

  url "https://github.com/{owner}/{app}/releases/download/v#{{version}}/{app}-#{{version}}-linux-#{{arch}}.tar.gz"
  name "{name}"
  desc "{desc}"
  homepage "{homepage}"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why: upstream's macOS build is a separate .dmg, which belongs in the
  # official homebrew/cask cask of the same name, not here. This tarball is
  # Linux ELF, so refuse to install anywhere else.
  depends_on linux: :any

  # Why both: the first is the GUI and the second is upstream's headless
  # command-line and MCP front end to the same engine, under the names the .deb
  # and .rpm install to /usr/bin.
{binaries}
  # Why upstream's reverse-DNS file names are kept: on Wayland the compositor
  # finds a window's launcher, and so its dock icon, by matching the window's
  # app_id against the installed .desktop file's name.
{artifacts}

  preflight_steps do
    # Why: upstream's entry runs the bare binary name and relies on the
    # session's PATH, which on a desktop usually lacks the Homebrew prefix — only
    # login shells that source brew's shellenv have it. Pointing Exec at the bin symlink keeps the
    # entry working across upgrades and keeps upstream's own arguments (%F).
    # No `audit_result: false`: an entry with no Exec line is a broken payload.
    inreplace "{root_step}/share/applications/{desktop_id}.desktop",
              /^Exec=\\S+/,
              "Exec={{{{HOMEBREW_PREFIX}}}}/bin/{app}"
    # Why TryExec too: a TryExec the shell cannot resolve hides the entry
    # outright, so leaving it bare would undo the Exec fix above. Not every app
    # sets one, hence `audit_result: false`.
    inreplace "{root_step}/share/applications/{desktop_id}.desktop",
              /^TryExec=.*$/,
              "TryExec={{{{HOMEBREW_PREFIX}}}}/bin/{app}",
              audit_result: false
  end

  # Why: without a refresh the launcher, its icon and the file associations only
  # appear after the next login. `must_succeed: false` keeps each step a no-op
  # on desktops that do not ship the tool.
  #
  # The paths are spelled out with `{{{{user}}}}` rather than `~` because these
  # steps run in Homebrew's cask sandbox, whose $HOME is an empty directory, and
  # `writable_paths` with `writable_base: :home` is what lets them write to the
  # real one. This is the same pattern every other desktop cask in this tap
  # uses; see paseo-linux.rb for the long version.
  postflight_steps do
{refresh}
  end

  uninstall_postflight_steps do
{refresh}
  end
{zap}
  caveats <<~EOS
    Homebrew owns this install's version. Upgrade with:
      brew upgrade --cask {token}

    `{app}` is the GUI and `{app}-cli` its command-line and MCP front end.
    The CLI needs nothing beyond glibc. The GUI loads its windowing and
    graphics stack at run time — Wayland or X11, libxkbcommon, and Vulkan or
    EGL — which any desktop session already has and Homebrew cannot supply.

    If you have run upstream's AppImage, it registered its own launcher and
    icons under ~/.local/share/applications and ~/.local/share/icons, and this
    install will refuse to overwrite them. Reinstall with --force to take them
    over.
  EOS
end
'''

REFRESH = '''\
    run "update-desktop-database",
        args:           ["."],
        chdir:          "/home/{{user}}/.local/share/applications",
        writable_paths: [".local/share/applications"],
        writable_base:  :home,
        must_succeed:   false
    run "gtk-update-icon-cache",
        args:           ["-f", "-t", "."],
        chdir:          "/home/{{user}}/.local/share/icons/hicolor",
        writable_paths: [".local/share/icons/hicolor"],
        writable_base:  :home,
        must_succeed:   false
    run "update-mime-database",
        args:           ["."],
        chdir:          "/home/{{user}}/.local/share/mime",
        writable_paths: [".local/share/mime"],
        writable_base:  :home,
        must_succeed:   false'''


def token(app: str) -> str:
    return f"{app}-linux"


def render(app: str, pin: dict) -> str:
    meta = APPS[app]
    root = f"{app}-#{{version}}-linux-#{{arch}}"
    root_step = f"{app}-{{{{version}}}}-linux-{{{{arch}}}}"
    manifest = pin["manifest"]

    binaries = "\n".join(f'  binary "{root}/bin/{b}"' for b in manifest["bin"])

    def artifact(rel: str) -> str:
        return f'  artifact "{root}/share/{rel}",\n           target: "#{{Dir.home}}/.local/share/{rel}"'

    shared = [f"applications/{manifest['desktop']}"]
    shared += [f"icons/hicolor/{i}" for i in manifest["icons"]]
    shared += [f"mime/packages/{m}" for m in manifest["mime"]]
    artifacts = "\n".join(artifact(rel) for rel in shared)

    zap_paths = meta["zap"]
    if not zap_paths:
        zap = ""
    elif len(zap_paths) == 1:
        zap = f'\n  zap trash: "{zap_paths[0]}"\n'
    else:
        zap = "\n  zap trash: [\n" + "".join(f'    "{p}",\n' for p in zap_paths) + "  ]\n"

    return TEMPLATE.format(
        token=token(app),
        app=app,
        owner=REPO_OWNER,
        name=meta["name"],
        desc=meta["desc"],
        homepage=meta["homepage"],
        version=pin["version"],
        sha_arm64=pin["sha256"]["arm64_linux"],
        sha_x86_64=pin["sha256"]["x86_64_linux"],
        desktop_id=manifest["desktop"].removesuffix(".desktop"),
        binaries=binaries,
        artifacts=artifacts,
        root_step=root_step,
        refresh=REFRESH,
        zap=zap,
    )


def get(url: str, timeout: int = 60):
    request = urllib.request.Request(url, headers={"User-Agent": "jakobhviid-homebrew-tap"})
    # A token lifts the 60/hour anonymous limit; only the API needs it.
    if url.startswith("https://api.github.com/") and (
        token_ := os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    ):
        request.add_header("Authorization", f"Bearer {token_}")
    return urllib.request.urlopen(request, timeout=timeout)


def retrying(fn, *args):
    """GitHub's release CDN returns the odd 500 and drops the odd stream; a
    scheduled bump should ride those out rather than fail the whole run."""
    for attempt in range(4):
        try:
            return fn(*args)
        except (urllib.error.URLError, TimeoutError, ConnectionError, EOFError, tarfile.ReadError) as error:
            # A 4xx is a real answer (a missing asset), not a blip.
            if isinstance(error, urllib.error.HTTPError) and error.code < 500:
                raise
            if attempt == 3:
                raise
            print(f"retrying after: {error}", file=sys.stderr)
            time.sleep(5 * 2**attempt)


class HashingReader(io.RawIOBase):
    """Feeds every byte tarfile reads through sha256, so one pass both lists
    the archive and proves it is the file SHA256SUMS.txt describes."""

    def __init__(self, raw):
        self.raw = raw
        self.digest = hashlib.sha256()

    def readable(self) -> bool:
        return True

    def readinto(self, buffer) -> int:
        data = self.raw.read(len(buffer))
        self.digest.update(data)
        buffer[: len(data)] = data
        return len(data)


def read_manifest(app: str, version: str, expected_sha: str) -> dict:
    """List the x86_64 tarball's payload without writing it to disk."""
    root = f"{app}-{version}-linux-x86_64"
    url = f"https://github.com/{REPO_OWNER}/{app}/releases/download/v{version}/{root}.tar.gz"
    files: list[str] = []
    with get(url, timeout=600) as response:
        reader = HashingReader(response)
        with tarfile.open(fileobj=io.BufferedReader(reader, 1 << 20), mode="r|gz") as tar:
            for member in tar:
                if member.isfile():
                    files.append(member.name)
        # Drain the gzip trailer tarfile may not have consumed.
        while reader.read(1 << 20):
            pass
    if reader.digest.hexdigest() != expected_sha:
        sys.exit(f"error: {url} does not match its SHA256SUMS.txt entry")

    rel = [f.removeprefix(f"{root}/") for f in files if f.startswith(f"{root}/")]
    if len(rel) != len(files):
        sys.exit(f"error: {app} {version}: tarball is not rooted at {root}/")

    def under(prefix: str, suffixes: tuple[str, ...]) -> list[str]:
        return sorted(
            f.removeprefix(prefix) for f in rel if f.startswith(prefix) and f.endswith(suffixes)
        )

    manifest = {
        "bin": under("bin/", ("",)),
        "desktop": under("share/applications/", (".desktop",)),
        # `.attribution` sidecars (EffectCraft, FilmCraft) are licence notes, not
        # icons; they would only clutter the icon theme.
        "icons": under("share/icons/hicolor/", (".png", ".svg")),
        "mime": under("share/mime/packages/", (".xml",)),
    }
    # The template assumes upstream's shape: the two binaries it documents and
    # exactly one launcher. Anything else is a packaging change a human should
    # look at, so fail the bump rather than render a guess.
    if manifest["bin"] != [app, f"{app}-cli"]:
        sys.exit(f"error: {app} {version}: unexpected binaries {manifest['bin']}")
    if manifest["desktop"] != [f"ai.storyteller.{app}.desktop"]:
        sys.exit(f"error: {app} {version}: unexpected desktop entries {manifest['desktop']}")
    if not manifest["icons"]:
        sys.exit(f"error: {app} {version}: no icons in the tarball")
    manifest["desktop"] = manifest["desktop"][0]
    return manifest


def latest_pin(app: str) -> dict:
    api = f"https://api.github.com/repos/{REPO_OWNER}/{app}/releases/latest"
    release = json.loads(retrying(lambda: get(api).read()))
    version = release["tag_name"].removeprefix("v")
    # The version is pasted into Ruby, file names and a commit message, so
    # refuse anything that is not a plain version string.
    if not re.fullmatch(r"[0-9][0-9A-Za-z.+-]*", version):
        sys.exit(f"error: {app}: refusing unexpected release tag {release['tag_name']!r}")
    sums_url = f"https://github.com/{REPO_OWNER}/{app}/releases/download/v{version}/SHA256SUMS.txt"
    sums = {}
    for line in retrying(lambda: get(sums_url).read()).decode().splitlines():
        if line.strip():
            sha, name = line.split()
            sums[name.lstrip("*")] = sha
    # Why trust SHA256SUMS.txt for aarch64 without downloading it: the x86_64
    # tarball is streamed and checked against the same file, which proves the
    # file describes this release; the pinned hash then makes brew verify the
    # aarch64 download itself, and the arm64 CI job installs it.
    shas = {}
    for key, arch in ARCHES.items():
        asset = f"{app}-{version}-linux-{arch}.tar.gz"
        if asset not in sums:
            sys.exit(f"error: {app} {version}: {asset} missing from SHA256SUMS.txt")
        shas[key] = sums[asset]
    return {
        "version": version,
        "sha256": shas,
        "manifest": retrying(read_manifest, app, version, shas["x86_64_linux"]),
    }


def main() -> None:
    args = sys.argv[1:]
    check = "--check" in args
    bump = "--bump" in args
    only = [a for a in args if not a.startswith("--")]
    unknown = [a for a in only if a not in APPS]
    if unknown:
        sys.exit(f"error: unknown app(s): {', '.join(unknown)}")
    if only and not bump:
        sys.exit("error: naming apps only makes sense with --bump")

    pins = json.loads(PINS.read_text(encoding="utf-8")) if PINS.exists() else {}

    if bump:
        for app in only or APPS:
            pin = latest_pin(app)
            old = pins.get(app, {}).get("version")
            if pin != pins.get(app):
                pins[app] = pin
                if old != pin["version"]:
                    print(f"{token(app)} {pin['version']}")
                print(f"{app}: {old} -> {pin['version']}", file=sys.stderr)
        ordered = {app: pins[app] for app in APPS if app in pins}
        PINS.write_text(json.dumps(ordered, indent=2) + "\n", encoding="utf-8")
        pins = ordered

    missing = [app for app in APPS if app not in pins]
    if missing:
        sys.exit(f"error: no pins for {', '.join(missing)}; run with --bump first")

    stale = []
    for app in APPS:
        path = CASK_DIR / f"{token(app)}.rb"
        rendered = render(app, pins[app])
        current = path.read_text(encoding="utf-8") if path.exists() else None
        if current == rendered:
            continue
        if check:
            stale.append(path.name)
        else:
            path.write_text(rendered, encoding="utf-8")
    if stale:
        sys.exit(f"error: out of date, run scripts/gen-craft-casks.py: {', '.join(stale)}")


if __name__ == "__main__":
    main()
