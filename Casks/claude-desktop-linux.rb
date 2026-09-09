cask "claude-desktop-linux" do
  # Why two numbers: upstream's tag and asset names carry the Claude build
  # (1.49585.0) and the packaging revision (3.2.4) as separate versions, and the
  # URL needs both — a repackaging fix ships a new 3.2.x against the same Claude
  # build. Homebrew's composite version keeps the pair in one stanza: `csv.first`
  # is Claude's, `csv.second` is the packaging's.
  version "1.49585.0,3.2.4"
  sha256 "c1c15459e1cc1ffe705cc594e555db9001e10f2db194e981a11a2bd7296e28a8"

  # The `+` in the tag `v3.2.4+claude1.49585.0` is percent-encoded, matching the
  # asset URL GitHub itself serves; an unencoded `+` is a different path.
  url "https://github.com/aaddrick/claude-desktop-debian/releases/download/v#{version.csv.second}%2Bclaude#{version.csv.first}/" \
      "claude-desktop-unofficial-#{version.csv.first}-#{version.csv.second}-1.x86_64.rpm"
  name "Claude Desktop"
  desc "Unofficial Linux repackaging of Anthropic's Claude desktop client"
  homepage "https://github.com/aaddrick/claude-desktop-debian"

  # Why a block: the default regex would take the first version-shaped run out of
  # `v3.2.4+claude1.49585.0`, which is the packaging revision, and this cask's
  # version is the pair the other way round.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)\+claude(\d+(?:\.\d+)+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      "#{match[2]},#{match[1]}"
    end
  end

  # Why: the payload is a glibc x86_64 RPM. Upstream publishes an aarch64 RPM of
  # every release too, so an arm64 machine is a version and a second cask entry
  # away — but the hash stays a single bare `sha256`, because arch-keying it
  # leaves `brew audit` on an arm64 runner with no hash to check at all.
  depends_on linux: :any
  depends_on arch: :x86_64

  # Why the long name: it is upstream's, shared by the deb and the rpm, and it is
  # what the .desktop entry and the launcher's autostart healing both name.
  # Unlike the Proton casks, this /usr/bin entry is not a symlink into ../lib —
  # it is a bash launcher that sets Chromium switches per session (Wayland vs
  # X11, XRDP GPU, password store), clears stale helpers and sockets, and then
  # execs the Electron binary. The preflight is what makes its baked-in paths
  # resolve inside the Caskroom; going straight at the Electron binary would skip
  # all of that.
  binary "usr/bin/claude-desktop-unofficial"
  artifact "usr/share/applications/claude-desktop-unofficial.desktop",
           target: "#{Dir.home}/.local/share/applications/claude-desktop-unofficial.desktop"
  # Why five sizes and not just the largest: GNOME picks an icon per context
  # (16px in lists, 48px in the dash, 256px in the switcher) and downscaling one
  # large PNG gives visibly soft launcher icons. These are real PNGs at every
  # size and there is no scalable/SVG icon in the payload.
  artifact "usr/share/icons/hicolor/16x16/apps/claude-desktop-unofficial.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/16x16/apps/claude-desktop-unofficial.png"
  artifact "usr/share/icons/hicolor/32x32/apps/claude-desktop-unofficial.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/32x32/apps/claude-desktop-unofficial.png"
  artifact "usr/share/icons/hicolor/48x48/apps/claude-desktop-unofficial.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/48x48/apps/claude-desktop-unofficial.png"
  artifact "usr/share/icons/hicolor/128x128/apps/claude-desktop-unofficial.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/128x128/apps/claude-desktop-unofficial.png"
  artifact "usr/share/icons/hicolor/256x256/apps/claude-desktop-unofficial.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/256x256/apps/claude-desktop-unofficial.png"

  preflight_steps do
    # Why rpm2cpio and not bsdtar: bsdtar is NOT installed on Bazzite, so a
    # libarchive-based extraction fails on the exact platform this cask targets.
    # And not rpm2archive either — its interface is not stable across rpm
    # versions: rpm 6 streams to stdout and creates no .tgz, while older releases
    # wrote FILE.tgz and printed nothing, so a pipeline built on it silently
    # extracts an empty archive on one of the two. rpm2cpio has written cpio to
    # stdout for decades and ships with rpm itself. A pipeline needs a shell, so
    # it runs through /bin/sh, and the glob names the staged RPM: its filename is
    # upstream's, not derived from `version`. A `run` step raises on a non-zero
    # exit, so a failed extraction aborts the install instead of leaving a
    # half-filled tree for the artifacts.
    run "/bin/sh",
        args:  ["-c", "rpm2cpio ./*.rpm | cpio -idmu --quiet"],
        chdir: "{{staged_path}}"

    # Why: the extracted tree is the install; keeping the 176 MB RPM as well
    # would double the Caskroom footprint for no benefit.
    remove "*.rpm"

    # Why: the launcher sources launcher-common.sh, execs the Electron binary and
    # cd's into the app directory, all by absolute /usr path, so none of it
    # resolves from the Caskroom until this rewrite. `{{staged_path}}` is the
    # versioned Caskroom directory the payload was just unpacked into, so it is
    # re-derived on every install and cannot go stale. inreplace raises when the
    # text is absent, which turns an upstream directory rename into a failed
    # install rather than a launcher that cannot find its own app.
    inreplace "usr/bin/claude-desktop-unofficial",
              "/usr/lib/claude-desktop-unofficial",
              "{{staged_path}}/usr/lib/claude-desktop-unofficial"
    # Why the prefix and not staged_path for this one: the launcher passes this
    # path to heal_autostart_entry, which writes it into
    # ~/.config/autostart/claude-desktop.desktop whenever the app's open-at-login
    # is on. That entry has to keep resolving after an upgrade has replaced the
    # versioned directory, so it gets the bin symlink.
    inreplace "usr/bin/claude-desktop-unofficial",
              "/usr/bin/claude-desktop-unofficial",
              "{{HOMEBREW_PREFIX}}/bin/claude-desktop-unofficial"

    # Why: upstream ships `Exec=/usr/bin/claude-desktop-unofficial %u`, which
    # points at a path only the system package provides. Point it at the bin
    # symlink, which is stable across version bumps, and keep `%u` so the
    # x-scheme-handler/claude association still receives its URL.
    inreplace "usr/share/applications/claude-desktop-unofficial.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/claude-desktop-unofficial %u"

    # Why: upstream's RPM ships chrome-sandbox setuid, which only means anything
    # on a root-owned file. A cask unpacks as you, so the bit survives extraction
    # attached to a file you own, where it grants nothing and Chromium rejects
    # the helper exactly as it would at 0755 — it takes the unprivileged
    # user-namespace sandbox instead. Clearing the bit makes the file say what it
    # is rather than leaving a user-owned setuid ELF in the Caskroom.
    set_permissions "usr/lib/claude-desktop-unofficial/chrome-sandbox", "0755",
                    recursive: false
  end

  # Why: without a database refresh the launcher and its claude:// handler only
  # appear after the next login — the entry declares
  # MimeType=x-scheme-handler/claude, so the mimeinfo.cache rebuild is what makes
  # `xdg-open claude://…` reach this app. `must_succeed: false` keeps the step a
  # no-op where the tool is not shipped.
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

  # Why these four: ~/.config/Claude is the Electron userData, verified directly
  # — it holds blob_storage, Cookies, Code Cache and Local State. The launcher
  # declares the other three itself: its log and config-backup directory under
  # ~/.cache/claude-desktop-debian, an optional `environment` file under
  # ~/.config/claude-desktop-debian, and the autostart entry it heals under that
  # exact filename.
  #
  # Deliberately absent, and each for its own reason. ~/.claude, ~/.claude.json
  # and ~/.cache/claude-cli-nodejs are Claude Code's — a different product whose
  # state a zap here must not touch. ~/.config/Claude-3p holds an MCP config that
  # nothing in this build references: neither the launcher nor the asar mentions
  # it, so its owner is unknown and it stays.
  zap trash: [
    "~/.cache/claude-desktop-debian",
    "~/.config/autostart/claude-desktop.desktop",
    "~/.config/Claude",
    "~/.config/claude-desktop-debian",
  ]

  caveats <<~EOS
    Homebrew owns this install's version. The package ships no self-updater, so
    brew is the only update path:
      brew upgrade --cask claude-desktop-linux

    This is aaddrick/claude-desktop-debian's community repackaging of Anthropic's
    client, not an Anthropic build.

    Remove any system-package copy of claude-desktop-unofficial (a dnf install or
    an rpm-ostree layer from pkg.claude-desktop-debian.dev). Both provide
    /usr/bin/claude-desktop-unofficial, and which one a launcher reaches then
    depends on PATH order.

    Claude Desktop is Electron, so it links against a desktop runtime (GTK 3,
    NSS, cups, ALSA) that Homebrew cannot supply. A desktop install already has
    it.

    The bundled chrome-sandbox is 0755 here: a cask unpacks as you, and a setuid
    bit counts only on a root-owned file. Chromium uses the unprivileged
    user-namespace sandbox instead, which needs user.max_user_namespaces > 0 —
    Fedora and Bazzite enable it by default. On Wayland the launcher passes
    --no-sandbox regardless; CLAUDE_FORCE_SANDBOX=1 keeps the sandbox on.
  EOS
end
