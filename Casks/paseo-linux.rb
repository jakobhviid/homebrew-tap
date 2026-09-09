cask "paseo-linux" do
  version "0.7.2"
  sha256 "56351d645dcc637fce47d3f58025647ac046ea8b488fd7858d30242a8db69b16"

  # Why the filename carries no version: upstream names the Linux AppImage after
  # the architecture only, so the release tag is the sole thing that moves. The
  # .deb and .rpm in the same release *are* versioned; if that convention ever
  # reaches the AppImage this URL 404s loudly rather than fetching the wrong build.
  url "https://github.com/getpaseo/paseo/releases/download/v#{version}/Paseo-x86_64.AppImage"
  name "Paseo"
  desc "Self-hosted control plane for running coding agents from any device"
  homepage "https://paseo.sh/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why: upstream ships Linux as an x86_64 AppImage only — there is no arm64
  # Linux asset in the release — so refuse to install anywhere else rather than
  # staging a payload that cannot run. The macOS builds are .dmg/.zip and are not
  # what this cask is for.
  depends_on linux: :any
  depends_on arch: :x86_64
  # Why the squashfs formula: extraction reads the image's embedded filesystem
  # with unsquashfs, so the tool has to be there on any host this installs on,
  # not only on the distributions that ship squashfs-tools themselves.
  depends_on formula: "squashfs"

  # Why: `paseo` is upstream's own CLI name — the bundled resources/bin/paseo is
  # the same script the macOS bundle exposes. It walks its own symlink chain back
  # into the bundle before exec'ing Electron in Node mode, so Homebrew's bin
  # symlink resolves correctly.
  binary "squashfs-root/resources/bin/paseo"
  # Why a second name for the GUI: the CLI already owns `paseo`, exactly as in
  # upstream's own layout, so the desktop launcher gets the name the packaged app
  # calls itself — package.json is `@getpaseo/desktop`, described as "Paseo
  # desktop app". It must launch through AppRun, not the raw Electron binary:
  # AppRun points LD_LIBRARY_PATH at the bundled libXss/libXtst/libnotify/
  # libappindicator, which the `Paseo` ELF does not find on its own.
  binary "squashfs-root/AppRun", target: "paseo-desktop"
  # Upstream's own capitalisation is kept throughout — the entry is Paseo.desktop
  # with Icon=Paseo, so the icon basenames have to match it.
  artifact "squashfs-root/Paseo.desktop",
           target: "#{Dir.home}/.local/share/applications/Paseo.desktop"
  # Why one 512px icon instead of the three upstream bundles: those stop at 128px
  # and inset the artwork in a transparent border — 114px of content on a 128px
  # canvas, 89% — so the launcher draws smaller than every neighbour that fills
  # its tile, and soft anywhere the shell asks for more than 128px. The same mark
  # ships at 512px with no border as the web UI's PWA icon, which is the size
  # this installs; hicolor declares 512x512 and GTK scales it per context.
  artifact "Paseo-512.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/Paseo.png"

  preflight_steps do
    # Why unsquashfs and not the image's own `--appimage-extract`: a type-2
    # AppImage unpacks itself by reopening its own file, and that reopen fails
    # inside a `run` step ("fopen error: Is a directory"). Unpacking with a
    # separate tool is the same split the Proton casks use, and it needs no
    # FUSE either.
    #
    # The offset comes out of the ELF header, so nothing has to execute: a
    # type-2 AppImage is an ELF followed by a squashfs filesystem, and the
    # boundary is the end of the section-header table — e_shoff (8 bytes at
    # 0x28) plus e_shnum (2 bytes at 0x3c) times e_shentsize (2 bytes at 0x3a).
    # `od` reads those three fields and is coreutils, so it costs no dependency
    # where readelf would pull in binutils. It is computed from the staged file
    # on every install because it moves with the bundled AppImage runtime.
    #
    # `-no-exit-code` is load-bearing: the step runs as the installing user, so
    # unsquashfs cannot restore the image's root ownership and grades that a
    # non-fatal error, which is exit 2 and would abort the install. It still
    # exits 1 on a fatal error, and `-ignore-errors` is deliberately absent, so
    # a file it cannot write is fatal rather than leaving a half-filled
    # squashfs-root for the artifacts. `-f` lets it descend into the
    # destination and `-n` drops the progress bar.
    run "/bin/sh",
        args:  ["-c", <<~'EXTRACT'],
          set -e
          image=./Paseo-x86_64.AppImage
          shoff=$(od -An -tu8 -j40 -N8 --endian=little "$image" | tr -d ' ')
          shentsize=$(od -An -tu2 -j58 -N2 --endian=little "$image" | tr -d ' ')
          shnum=$(od -An -tu2 -j60 -N2 --endian=little "$image" | tr -d ' ')
          {{HOMEBREW_PREFIX}}/bin/unsquashfs -no-exit-code -n -f \
            -o "$((shoff + shnum * shentsize))" -d squashfs-root "$image"
        EXTRACT
        chdir: "{{staged_path}}"

    # Why: the extracted tree is the install; keeping the 143 MB image too would
    # double the Caskroom footprint for no benefit.
    remove "Paseo-x86_64.AppImage"

    # Why this one-word patch is load-bearing: upstream's AppRun finds its AppDir
    # by walking *up* from its own location until it finds a directory containing
    # "$1" — the first command-line argument, which is only ever an AppDir marker
    # by accident. Inside a mounted AppImage nothing notices, because the AppImage
    # runtime exports APPDIR and the discovery block is skipped entirely. Run from
    # an extracted tree, APPDIR is unset, so the loop runs — and since upstream's
    # own Exec passes `--no-sandbox %U`, "$1" is a flag that exists nowhere, the
    # walk climbs past / and sets APPDIR to the empty string. The launcher then
    # execs "/Paseo" and dies with "No such file or directory" (verified against
    # 0.7.2). Testing for AppRun instead is what the loop was reaching for: the
    # AppDir is the directory AppRun lives in, so it now terminates immediately
    # and correctly whether or not arguments were passed.
    inreplace "squashfs-root/AppRun",
              '! -e "$path/$1"',
              '! -e "$path/AppRun"'

    # Why: Paseo ships an electron-updater manifest pointed at its own GitHub
    # releases. It cannot actually damage this install — AppRun assigns APPIMAGE
    # without exporting it, so AppImageUpdater finds no image to overwrite and
    # fails at its install step instead of replacing AppRun — but dropping the
    # manifest removes the reason for the app to fetch a release it cannot
    # install, and keeps brew unambiguously in charge of the version.
    remove "squashfs-root/resources/app-update.yml"

    # Why: `Exec=AppRun --no-sandbox %U` only resolves inside a mounted AppImage.
    # Point it at the Homebrew bin symlink so the entry survives version bumps,
    # and keep both of upstream's arguments: %U is what feeds the
    # x-scheme-handler/paseo association its URL, and --no-sandbox is upstream's
    # own launch flag, not this cask's choice (see the caveats). No
    # `audit_result: false` here: a .desktop with no Exec line is a broken payload
    # and should fail the install loudly.
    inreplace "squashfs-root/Paseo.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/paseo-desktop --no-sandbox %U"
    # Why: brew owns the version here, so an AppImage-provenance stamp would go
    # stale on the first upgrade and misreport what's installed. `audit_result:
    # false` keeps a build that omits the key installable — `inreplace` raises on
    # an absent pattern.
    inreplace "squashfs-root/Paseo.desktop",
              /^X-AppImage-Version=.*\n/,
              "",
              audit_result: false
    # Why a copy rather than an artifact pointed straight at the PWA icon:
    # `artifact` MOVES its source, and app-dist is the web UI itself — the daemon
    # serves that directory to browsers and phones, and its manifest.json asks
    # for /pwa-icon-512.png by name. Moving it would fix the launcher by putting
    # a 404 in the web app. This copy is what gets moved out.
    copy "squashfs-root/resources/app-dist/pwa-icon-512.png", "Paseo-512.png"

    # Categories=Development; and StartupWMClass=Paseo are left untouched: the
    # first already lands the entry where it belongs, and the second is what lets
    # the shell group Paseo's windows under this launcher icon.
  end

  # Why: without a database refresh the entry and its URL handler only appear
  # after the next login. `must_succeed: false` keeps the step a no-op on
  # desktops that don't ship the tool.
  #
  # The path is spelled out with `{{user}}` rather than `~`, and that is
  # load-bearing. These steps run inside Homebrew's cask sandbox, which has its
  # own empty $HOME, so `~` expands to a directory that does not exist — both
  # refreshes then silently no-op and `must_succeed: false` hides it. There is
  # no `{{home}}` token (the runner's token list is prefix/staged_path/appdir
  # and friends, plus `{{user}}`), `chdir` resolves only against the step's
  # default base, and interpolating #{Dir.home} is rejected by the style cop,
  # which allows only step DSL calls and literal arguments inside a steps
  # block. Hardcoding /home is safe here because the cask is Linux-only.
  #
  # `writable_paths` is load-bearing for the same reason: the sandbox grants a
  # step write access to the Caskroom, the appdir and the linked prefix
  # directories only, so without it update-desktop-database reports "The
  # databases in [.] could not be updated" and gtk-update-icon-cache reports
  # "Permission denied" on .icon-theme.cache — both swallowed by
  # `must_succeed: false`. `writable_base: :home` resolves against the real
  # home the runner is handed, not the sandbox's empty $HOME.
  postflight_steps do
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
  end

  uninstall_postflight_steps do
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
  end

  # Why these three: ~/.paseo is the daemon's home — config.json, daemon.log,
  # agents/, worktrees/, the machine keypair — and is resolved from $PASEO_HOME
  # or $HOME, on every platform. The other two are Electron's, and the
  # capitalisation is the app's own: main.js calls setName("Paseo"), which was
  # confirmed by a run against a throwaway $HOME creating ~/.config/Paseo. That
  # run left no ~/.cache/Paseo, but Electron places its shader and crash caches
  # there on setups where userData is not doing that job, and zapping a path that
  # was never created is a no-op.
  zap trash: [
    "~/.cache/Paseo",
    "~/.config/Paseo",
    "~/.paseo",
  ]

  caveats <<~EOS
    Homebrew owns this install's version. Paseo's own updater cannot replace it,
    because an extracted AppImage leaves it nothing to write back to. Upgrade
    with:
      brew upgrade --cask paseo-linux

    `paseo` is the CLI and `paseo-desktop` is the GUI, matching upstream's own
    split. Both are Electron, so they link against a desktop runtime (GTK 3, NSS,
    cups, ALSA) that Homebrew cannot supply. A desktop install already has it. On
    a headless host, install your distribution's Electron or Chromium
    dependencies first, or the binaries will fail at load time rather than on
    launch.

    The desktop entry keeps upstream's own `--no-sandbox` flag, which is how
    Paseo ships its Linux launcher: the Chromium sandbox is off. Nothing about
    this cask requires it — the app starts without it on a host whose
    unprivileged user namespaces are enabled — so if you would rather keep the
    sandbox, drop the flag from
    ~/.local/share/applications/Paseo.desktop, or launch `paseo-desktop`
    directly.

    Starting the app starts a background daemon (`Paseo Daemon`) that outlives
    the window and keeps its state in ~/.paseo. Uninstalling does not stop a
    daemon that is already running.
  EOS
end
