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
| [crw](https://github.com/us/crw) | Turn URLs into clean markdown or JSON — scrape, crawl, search, MCP server | macOS, Linux (x86_64, arm64) |
| [dotsync](https://github.com/jakobhviid/dotsync) | Sync user-level config between machines through a cloud folder, using symlinks | macOS, Linux (x86_64, arm64) |
| [grove](https://github.com/jakobhviid/grove) | Portable git shortcuts plus a multi-repo overview & sync, for any shell | macOS, Linux (x86_64, arm64) |
| [llama-matrix](https://github.com/jakobhviid/llama-matrix) | Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM | macOS, Linux (x86_64, arm64) |
| [opencode-provider-manager](https://github.com/jakobhviid/opencode-provider-manager) | Install & manage the opencode-provider-manager plugin for opencode | macOS, Linux (x86_64, arm64) |
| [orca-linux](https://onorca.dev/) | IDE for orchestrating AI coding agents across terminals and worktrees | Linux (x86_64, arm64) |
| [proton-drive-cli](https://proton.me/drive) | Access Proton Drive end-to-end encrypted cloud storage from the terminal | macOS, Linux (x86_64, arm64) |
| [pwtune](https://github.com/jakobhviid/pwtune) | Measure any speaker with any mic and build a PipeWire EQ profile | Linux (arm64) |
| [temper](https://github.com/jakobhviid/temper) | Converge a machine to a declared spec kept in a folder of human-readable files | macOS, Linux (x86_64, arm64) |
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

- **Formulae are generated, not hand-written.** Each tool's own release CI
  regenerates its formula and commits it here, which is why version bumps land
  as commits like `temper 1.26.0`. Bottles are built in CI, attached to that
  tool's GitHub release, and pinned by `sha256` in the formula.
- **The tool list above is generated too.** `scripts/gen-readme.py` reads every
  `Formula/*.rb` and `Casks/*.rb` and rewrites the table between the
  `BEGIN TOOLS` / `END TOOLS` markers. A GitHub Actions workflow runs it on any
  push that touches `Formula/` or `Casks/`, so the catalog can't drift —
  nothing here is a hand-kept list.
  To refresh it locally: `python3 scripts/gen-readme.py` (or `--check` in CI).
