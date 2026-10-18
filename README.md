# jakobhviid/homebrew-tap

A personal [Homebrew](https://brew.sh) tap — prebuilt CLI tools and desktop apps for
macOS and Linux.

```sh
brew trust --tap jakobhviid/tap   # Homebrew 6 won't load a third-party tap until it's trusted
brew tap jakobhviid/tap
brew install jakobhviid/tap/<tool>
```

Where a prebuilt bottle exists, `brew install` pours a binary directly — no C
toolchain or Xcode required, which matters on minimal servers and immutable
distros. Platforms without a matching bottle fall back to a direct download.

The catalog mixes formulae and casks. A cask ships a prebuilt desktop app —
launcher entry and icon included — and installs with the same command; run
`brew info jakobhviid/tap/<tool>` to see which kind an entry is.

## Tools

<!-- BEGIN TOOLS (auto-generated from Formula/*.rb and Casks/*.rb — do not edit by hand) -->
| Tool | What it does | Platforms |
| --- | --- | --- |
| [amdl](https://github.com/jakobhviid/amdl) | Maintain a uniform Opus music library: complete tags, cover art, and lyrics | macOS, Linux (x86_64, arm64) |
| [artcraft-launcher-linux](https://github.com/storytold/craft-launcher) | Installer and updater for the ArtCraft Crafting Apps | Linux (x86_64, arm64) |
| [cadcraft-linux](https://getartcraft.com/apps/cadcraft) | AutoCAD-style 2D drafting and design app | Linux (x86_64, arm64) |
| [claude-desktop-linux](https://github.com/aaddrick/claude-desktop-debian) | Unofficial Linux repackaging of Anthropic's Claude desktop client | Linux (x86_64) |
| [crw](https://github.com/us/crw) | Turn URLs into clean markdown or JSON — scrape, crawl, search, MCP server | macOS, Linux (x86_64, arm64) |
| [deckcraft-linux](https://getartcraft.com/apps/deckcraft) | Microsoft PowerPoint-style presentation app | Linux (x86_64, arm64) |
| [designcraft-linux](https://getartcraft.com/apps/designcraft) | InDesign-style page layout and publishing app | Linux (x86_64, arm64) |
| [dotsync](https://github.com/jakobhviid/dotsync) | Sync user-level config between machines through a cloud folder, using symlinks | macOS, Linux (x86_64, arm64) |
| [effectcraft-linux](https://getartcraft.com/apps/effectcraft) | After Effects-style motion graphics and VFX compositor | Linux (x86_64, arm64) |
| [figcraft-linux](https://getartcraft.com/apps/figcraft) | Figma-style interface design and prototyping app | Linux (x86_64, arm64) |
| [filmcraft-linux](https://getartcraft.com/apps/filmcraft) | Premiere-style video editor | Linux (x86_64, arm64) |
| [gridcraft-linux](https://getartcraft.com/apps/gridcraft) | Microsoft Excel-style spreadsheet | Linux (x86_64, arm64) |
| [grove](https://github.com/jakobhviid/grove) | Portable git shortcuts plus a multi-repo overview & sync, for any shell | macOS, Linux (x86_64, arm64) |
| [lightcraft-linux](https://getartcraft.com/apps/lightcraft) | Lightroom-style photo library and raw developer | Linux (x86_64, arm64) |
| [llama-matrix](https://github.com/jakobhviid/llama-matrix) | Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM | macOS, Linux (x86_64, arm64) |
| [opencode-provider-manager](https://github.com/jakobhviid/opencode-provider-manager) | Install & manage the opencode-provider-manager plugin for opencode | macOS, Linux (x86_64, arm64) |
| [orca-linux](https://onorca.dev/) | IDE for orchestrating AI coding agents across terminals and worktrees | Linux (x86_64, arm64) |
| [paseo-linux](https://paseo.sh/) | Self-hosted control plane for running coding agents from any device | Linux (x86_64) |
| [pdfcraft-linux](https://getartcraft.com/apps/pdfcraft) | Acrobat-style PDF reader and editor | Linux (x86_64, arm64) |
| [photocraft-linux](https://getartcraft.com/apps/photocraft) | Photoshop-style image editor | Linux (x86_64, arm64) |
| [proton-drive-cli](https://proton.me/drive) | Access Proton Drive end-to-end encrypted cloud storage from the terminal | macOS, Linux (x86_64, arm64) |
| [proton-mail-linux](https://proton.me/mail) | Encrypted email client | Linux (x86_64) |
| [proton-meet-linux](https://proton.me/meet) | End-to-end encrypted video conferencing | Linux (x86_64) |
| [proton-pass-linux](https://proton.me/pass) | Password manager | Linux (x86_64) |
| [pwtune](https://github.com/jakobhviid/pwtune) | Measure any speaker with any mic and build a PipeWire EQ profile | Linux (arm64) |
| [soundcraft-linux](https://getartcraft.com/apps/soundcraft) | Pro Tools-style digital audio workstation | Linux (x86_64, arm64) |
| [temper](https://github.com/jakobhviid/temper) | Converge a machine to a declared spec kept in a folder of human-readable files | macOS, Linux (x86_64, arm64) |
| [vectorcraft-linux](https://getartcraft.com/apps/vectorcraft) | Illustrator-style vector graphics editor | Linux (x86_64, arm64) |
| [wordcraft-linux](https://getartcraft.com/apps/wordcraft) | Microsoft Word-style word processor | Linux (x86_64, arm64) |
<!-- END TOOLS -->

Each tool's own repository (linked above) is the place for its usage docs. Some
formulae print setup notes on install and need runtime pieces the table doesn't
capture — e.g. `pwtune` needs PipeWire, `grove` has an optional shell-alias
setup step, and `proton-drive-cli` can use `pass` as a keyring on headless
Linux. Run `brew info jakobhviid/tap/<tool>` to see a tool's caveats and deps.

## Managing tools

```sh
brew search jakobhviid/tap/       # list everything in this tap
brew info jakobhviid/tap/<tool>   # description, version, homepage, deps, caveats
brew upgrade <tool>               # update to the latest release
brew uninstall <tool>             # remove a tool
brew untap jakobhviid/tap         # remove the tap entirely
```

## How this tap is maintained

- **Nothing reaches `main` untested.** Every change made unattended goes
  through the same three steps: propose it on a scratch branch, install and
  test it on every platform it claims, and land each package that passed —
  which is why version bumps land as commits like `temper 1.26.0`. One broken
  package holds back only itself, and gets one GitHub issue (label
  `ci-failure`) that closes itself once it passes again. No open issues means
  everything is current.
- **Formulae are generated, not hand-written.** Each tool's own release CI
  renders its formula and pushes it to `auto/formula-<name>` here, and the gate
  workflow lands it once it installs and passes `brew test`. Bottles are built
  in CI, attached to that tool's GitHub release, and pinned by `sha256` in the
  formula.
- **Casks are bumped daily** from upstream's releases, through the same steps.
  A daily freshness check (`brew livecheck`) also flags any package left behind
  upstream, in case whatever should have moved it has quietly stopped.
- **The tool list above is generated too.** `scripts/gen-readme.py` reads every
  `Formula/*.rb` and `Casks/*.rb` and rewrites the table between the
  `BEGIN TOOLS` / `END TOOLS` markers. Landing a package runs it, and CI fails
  any other change to `Formula/` or `Casks/` that leaves the table behind, so
  the catalog can't drift — nothing here is a hand-kept list.
  To refresh it locally: `python3 scripts/gen-readme.py` (or `--check` in CI).
- **The `*craft-linux` casks share one template.** ArtCraft's Crafting Apps all
  come out of the same release pipeline, so `scripts/gen-craft-casks.py`
  renders the fourteen casks — thirteen apps and ArtCraft Launcher — from a single template plus the pins in
  `scripts/craft-casks.json`. Edit those, not the casks — CI fails on drift.
  The daily bump moves each app's pin on its own and lands each app that
  installs cleanly on both architectures.
- **The `*craft-linux` casks are not the official ones.** homebrew/cask carries
  all thirteen apps under their plain names (`brew install --cask photocraft`),
  for macOS and, since October 2026, Linux too. On Linux those install
  upstream's AppImage as it is, into `~/Applications`. These unpack upstream's
  tarball into a regular install instead: launcher, icons and file
  associations from the cask, the GUI and its CLI on `PATH`, no FUSE needed,
  and all of it removed on uninstall. Use the official casks on macOS, and pick
  one or the other on Linux, not both — the AppImage registers its own
  launcher the first time it runs, and the `-linux` cask will not overwrite it.
- **`artcraft-launcher-linux` has no official counterpart.** It installs
  ArtCraft Launcher, which installs and updates the apps itself, in the
  system's own formats and outside Homebrew. Use it instead of the app casks
  or alongside them: it opens apps the casks installed and leaves updating
  them to Homebrew. `brew info` spells out the details.
