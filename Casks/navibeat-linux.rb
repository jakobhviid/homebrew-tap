cask "navibeat-linux" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.0.62"
  sha256 arm64_linux:  "37b4a8923d4794a000598b6380d845bb6c21ccf9aedc59354f3daf263015943f",
         x86_64_linux: "16a0d20362d21c80c90aaaa01242c9fd886396ef0bcbdd45c07dff637bcb0dd0"

  # Why the full image and not the `-slim` one beside it: slim leaves out the
  # bundled libVLC and plays through the system's, which Homebrew cannot supply
  # on Linux. The filename carries no version, so the release tag is the only
  # part of the URL that moves.
  url "https://github.com/nenadjokic/navibeat-linux/releases/download/v#{version}/NaviBeat-linux-#{arch}.AppImage"
  name "NaviBeat"
  desc "Desktop music player for Navidrome and other OpenSubsonic servers"
  homepage "https://navibeat.app/linux"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why imagemagick: the only icon upstream ships, in the AppImage and the .deb
  # alike, is a macOS-style export — an 824px squircle in a 1024px canvas, Apple's
  # icon grid exactly — so on a Linux desktop the launcher draws about a fifth
  # smaller than every neighbour that fills its tile. The jar's other copy of the
  # mark is a full-bleed square with no transparency at all, so it would trade
  # the margin for hard corners. That leaves cropping, and `magick -trim` takes
  # the edge from the artwork itself rather than from a number pinned here.
  depends_on formula: "imagemagick"
  # Why the squashfs formula: extraction reads the image's embedded filesystem
  # with unsquashfs, so the tool has to be there on any host this installs on,
  # not only on the distributions that ship squashfs-tools themselves.
  depends_on formula: "squashfs"
  # Why: the AppImage is a Linux ELF, so refuse to install anywhere else rather
  # than staging a broken payload. Upstream's Apple builds are separate, paid
  # apps that this cask does not cover.
  depends_on linux: :any

  # Why one binary for both the window and the terminal client: `navibeat` opens
  # the GUI, or the terminal client by itself where there is no display, and
  # `--tui`, `--search` and the other flags run from the same launcher. The name
  # is what upstream's own deb, rpm and Arch packages install. AppRun is the launcher those packages copy verbatim:
  # it points LD_LIBRARY_PATH and VLC_PLUGIN_PATH at the bundled libVLC, without
  # which the app starts and plays nothing. It finds that tree through
  # `readlink -f "$0"`, so Homebrew's bin symlink resolves correctly.
  binary "squashfs-root/AppRun", target: "navibeat"
  # Why lowercase, unlike the AppImage's NaviBeat.desktop: navibeat.desktop is
  # the desktop ID upstream's AppStream metadata declares and its native packages
  # install. The app's opt-in GNOME search provider also publishes itself under
  # the first entry whose name starts with "navibeat", searching
  # ~/.local/share/applications first, so this is the one it will name.
  artifact "squashfs-root/NaviBeat.desktop",
           target: "#{Dir.home}/.local/share/applications/navibeat.desktop"
  # Why one 512px icon: upstream ships the single 1024px export and nothing else.
  # The preflight crops it to its own edges; hicolor declares 512x512 and GTK
  # scales that per context.
  artifact "navibeat-512.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/navibeat.png"

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
          image=./NaviBeat-linux-{{arch}}.AppImage
          shoff=$(od -An -tu8 -j40 -N8 --endian=little "$image" | tr -d ' ')
          shentsize=$(od -An -tu2 -j58 -N2 --endian=little "$image" | tr -d ' ')
          shnum=$(od -An -tu2 -j60 -N2 --endian=little "$image" | tr -d ' ')
          {{HOMEBREW_PREFIX}}/bin/unsquashfs -no-exit-code -n -f \
            -o "$((shoff + shnum * shentsize))" -d squashfs-root "$image"
        EXTRACT
        chdir: "{{staged_path}}"

    # Why: upstream's image makes the AppDir root and every directory under usr/
    # mode 0700; only the vlc/ tree is 0755. Mounted read-only that never shows,
    # but extracted it would leave the install usable by the installing user
    # alone, where the same tree in upstream's .deb is 0755. `X` adds search only
    # where it is already set for someone, so plain files stay non-executable.
    run "/bin/chmod",
        args:  ["-R", "go+rX", "squashfs-root"],
        chdir: "{{staged_path}}"

    # Why: the extracted tree is the install; keeping the 210 MB image too would
    # double the Caskroom footprint for no benefit.
    remove "NaviBeat-linux-{{arch}}.AppImage"

    # Nothing to disable, unlike the Electron casks: the only update feed the app
    # carries is its Windows one, and the AppImage's embedded zsync pointer is
    # read only by external AppImage updaters, which have no image left to act on.

    # Why: `Exec=NaviBeat` names nothing on PATH, so the entry would not launch.
    # Point it at the Homebrew bin symlink so it survives version bumps. No
    # arguments to keep: the entry declares no MimeType and takes none. No
    # `audit_result: false` here, unlike the one below: a .desktop with no Exec
    # line is a broken payload and should fail the install loudly.
    inreplace "squashfs-root/NaviBeat.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/navibeat"
    # Why: the icon installs under the lowercase name the native packages use, so
    # the entry has to ask for that one. Icon is an optional key, so
    # `audit_result: false` keeps a build that omits it installable — `inreplace`
    # raises on an absent pattern.
    inreplace "squashfs-root/NaviBeat.desktop",
              /^Icon=.*$/,
              "Icon=navibeat",
              audit_result: false
    # Why trim and then resize: `-trim` removes only the fully transparent
    # border, landing the squircle at the full canvas, and `+repage` drops the
    # offset it records, or the resize would reintroduce the margin it just
    # removed. NaviBeat.png at the AppDir root is the same file as .DirIcon and
    # usr/lib/NaviBeat.png, so which of the three this reads does not matter.
    run "{{HOMEBREW_PREFIX}}/bin/magick",
        args:  ["squashfs-root/NaviBeat.png",
                "-trim", "+repage", "-resize", "512x512", "navibeat-512.png"],
        chdir: "{{staged_path}}"

    # Categories=AudioVideo;Audio;Player; and StartupWMClass=app-navibeat-
    # desktop-MainKt are left untouched: the first already lands the entry where
    # it belongs, and the second is what lets the shell group NaviBeat's windows
    # under this launcher icon.
  end

  # Why: without a database refresh the entry only appears after the next login.
  # `must_succeed: false` keeps the step a no-op on desktops that don't ship the
  # tool.
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

  # Why these: the app resolves its config, cache and data roots through the XDG
  # variables, each with a lowercase `navibeat` directory under it; a bare launch
  # was observed creating the config and data ones. The GNOME search provider is
  # off by default, and when it is on it writes its .ini while the app runs and
  # deletes it on a clean exit, so this entry is for the one a crash leaves. The
  # Java preferences node `app/navibeat` is where the app's licensing code keeps
  # its state; the `rmdir` clears the `app` level above it only once nothing
  # else uses it.
  zap trash: [
        "~/.cache/navibeat",
        "~/.config/navibeat",
        "~/.java/.userPrefs/app/navibeat",
        "~/.local/share/gnome-shell/search-providers/app.navibeat.SearchProvider.ini",
        "~/.local/share/navibeat",
      ],
      rmdir: "~/.java/.userPrefs/app"

  caveats <<~EOS
    Homebrew owns this install's version; upgrade with:
      brew upgrade --cask navibeat-linux

    Install this or upstream's apt, dnf or pacman package, not both. Both
    provide `navibeat` and a navibeat.desktop launcher, and this cask's
    launcher hides the system one.

    The title bar's TUI button, which opens terminal mode in a new terminal
    window, appears only when NaviBeat runs as an AppImage. Upstream's own
    packages leave it out too. Run `navibeat --tui` from a terminal instead.

    NaviBeat needs glibc 2.36 or newer, and a Navidrome (v0.50+) or other
    OpenSubsonic server to play from.
  EOS
end
