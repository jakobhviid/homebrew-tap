cask "orca-linux" do
  # Why: the x86_64 asset carries no arch suffix (`orca-linux.AppImage`) while
  # arm64 does, so the suffix — not a bare arch name — is what varies; on
  # x86_64 `arch` is nil and interpolates away.
  arch arm: "-arm64"

  version "1.4.197"
  sha256 arm64_linux:  "9a6c9cc3be3f9886efa8d75d16ba3401a029cd261235a86b84cd1c2436139271",
         x86_64_linux: "4bc8462d151ff010faa54c646bb16dcc5474bf664eed5ec5028182d79926416b"

  url "https://github.com/stablyai/orca/releases/download/v#{version}/orca-linux#{arch}.AppImage"
  name "Orca"
  desc "IDE for orchestrating AI coding agents across terminals and worktrees"
  homepage "https://onorca.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why: upstream's cask covers macOS; this one exists only because the official
  # `orca` cask name is taken by plotly's chart exporter. The AppImage is a Linux
  # ELF, so refuse to install anywhere else rather than staging a broken payload.
  depends_on linux: :any

  # Why: `orca` is the CLI, matching upstream's macOS cask and Orca's own Linux
  # CliInstaller, which symlinks ~/.local/bin/orca. The shim walks symlinks to
  # find its app dir, so Homebrew's bin symlink resolves correctly.
  binary "squashfs-root/resources/bin/orca-ide", target: "orca"
  # Why: the GUI must launch through AppRun, not the raw Electron binary. AppRun
  # probes `unshare -Ur` and appends --no-sandbox when user namespaces are
  # unavailable, and points LD_LIBRARY_PATH at the bundled libXss/libXtst/
  # libnotify/libappindicator. Launching orca-ide directly skips both. The name
  # matches Orca's Linux executable and the deb/rpm binary.
  binary "squashfs-root/AppRun", target: "orca-ide"
  artifact "squashfs-root/orca-ide.desktop",
           target: "#{Dir.home}/.local/share/applications/orca-ide.desktop"
  # Why: install all eight bundled sizes, not just 512x512. GNOME picks an icon
  # per context (16px in lists, 48px in the dash, 256px in the switcher) and
  # downscaling one large PNG gives visibly soft launcher icons.
  artifact "squashfs-root/usr/share/icons/hicolor/16x16/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/16x16/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/24x24/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/24x24/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/32x32/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/32x32/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/48x48/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/48x48/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/64x64/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/64x64/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/128x128/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/128x128/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/256x256/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/256x256/apps/orca-ide.png"
  artifact "squashfs-root/usr/share/icons/hicolor/512x512/apps/orca-ide.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/orca-ide.png"

  # `preflight` deliberately stays in the pre-steps form — every other stanza
  # here is migrated — and test-cask.yml skips Cask/InstallSteps for this one.
  # Migrating it makes the AppImage's own extraction fail:
  #
  #   `… orca-linux.AppImage --appimage-extract` exited with 1
  #   fopen error: Is a directory
  #
  # A type-2 AppImage reopens its own file to read the embedded squashfs, and
  # something about how a `run` step executes it stops that working. Three
  # things were ruled out on real installs: the /usr/bin/env wrapper (routing
  # through `/bin/sh -c` fails identically), the step sandbox's write
  # permissions (`writable_paths: ["{{staged_path}}"]` changes nothing), and the
  # cask itself (this form installs cleanly). The blocker is inside the step
  # runner.
  #
  # The Proton casks in this tap extract in a `preflight_steps` block and pass,
  # because their payload is unpacked by a separate tool (`rpm2cpio | cpio`)
  # instead of by the payload executing itself. That is the distinction to keep
  # if anyone retries this: extracting via unsquashfs, or `write_file`-ing a
  # small extract script, are the two avenues left.
  preflight do
    appimage = "#{staged_path}/orca-linux#{arch}.AppImage"

    # Why: the type-2 AppImage runtime unpacks itself with its own embedded
    # squashfs reader, so this needs neither FUSE nor an unsquashfs on PATH —
    # which matters for a tap user who isn't on Fedora. system_command raises on
    # a non-zero exit, unlike Kernel#system, so a failed extraction aborts the
    # install instead of leaving a half-filled squashfs-root for the artifacts.
    system_command "chmod", args: ["+x", appimage]
    system_command appimage, args: ["--appimage-extract"], chdir: staged_path

    # Why: the extracted tree is the install; keeping the 193 MB image too would
    # double the Caskroom footprint for no benefit.
    FileUtils.rm appimage

    # Why: Orca ships an electron-updater manifest and marks
    # resources/package-type as "AppImage", so the app treats itself as
    # self-updating. It cannot actually damage this install: AppRun assigns
    # APPIMAGE without exporting it, so AppImageUpdater finds no image to
    # overwrite and its install step fails instead of replacing AppRun. Dropping
    # the manifest removes the remaining reason for the app to fetch a release it
    # cannot install, and keeps brew unambiguously in charge of the version.
    # The app configures its feed programmatically, so treat this as belt rather
    # than braces — `brew upgrade` is the update path either way.
    FileUtils.rm "#{staged_path}/squashfs-root/resources/app-update.yml"

    desktop = "#{staged_path}/squashfs-root/orca-ide.desktop"
    content = File.read(desktop)
    # Why: `Exec=AppRun %U` only resolves inside a mounted AppImage. Point it at
    # the Homebrew bin symlink so the entry survives version bumps, and keep %U
    # so the x-scheme-handler/orca and text/markdown handlers still get their arg.
    content.gsub!(/^Exec=.*$/, "Exec=#{HOMEBREW_PREFIX}/bin/orca-ide %U")
    # Why: an IDE under Utility lands in GNOME's "Utilities" folder.
    content.gsub!(/^Categories=.*$/, "Categories=Development;IDE;")
    # Why: brew owns the version here, so an AppImage-provenance stamp would go
    # stale on the first upgrade and misreport what's installed.
    content.gsub!(/^X-AppImage-Version=.*\n/, "")
    File.write(desktop, content)
    # StartupWMClass=orca is left untouched: it's what lets the shell group
    # Orca's windows under this launcher icon.
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

  # Why: Orca keeps worktrees and agent state in ~/.orca, as it does on macOS,
  # plus Electron's userData directory. That directory is lowercase `orca`: the
  # packaged app.asar declares `name: "orca"` with no productName and never calls
  # setPath, and a real Linux install was observed creating ~/.config/orca. The
  # capitalised macOS spelling would silently miss it on a case-sensitive volume.
  zap trash: [
    "~/.cache/orca",
    "~/.config/orca",
    "~/.orca",
  ]

  caveats <<~EOS
    Homebrew owns this install's version. Orca's own updater cannot replace it,
    because an extracted AppImage leaves it nothing to write back to, but it can
    still report a release it is unable to install. Upgrade with:
      brew upgrade --cask orca-linux

    Both `orca` and `orca-ide` are Electron, so they link against a desktop
    runtime (GTK 3, NSS, cups, ALSA) that Homebrew cannot supply. A desktop
    install already has it. On a headless host, install your distribution's
    Electron or Chromium dependencies before running `orca serve`, or the
    binaries will fail at load time rather than on launch.
  EOS
end
