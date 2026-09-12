cask "claude-desktop-linux" do
  # Why two numbers: upstream's tag and asset names carry the Claude build
  # (1.49585.0) and the packaging revision (3.2.4) as separate versions, and the
  # URL needs both — a repackaging fix ships a new 3.2.x against the same Claude
  # build. Homebrew's composite version keeps the pair in one stanza: `csv.first`
  # is Claude's, `csv.second` is the packaging's.
  version "1.52386.3,3.2.4"
  sha256 "74c1a4d74cc0accf0a4ec3a2d2592e4ca7badf6813c8c2111114fba43fd2006a"

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
  depends_on arch: :x86_64
  depends_on linux: :any

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
  # Why one 512px icon instead of upstream's five hicolor PNGs: those are the
  # same artwork inset in a transparent border — 212px of content on a 256px
  # canvas, 83% — so the launcher draws noticeably smaller than every neighbour
  # that fills its tile. The app's own Electron icon, resources/icon.png, is the
  # same art at 512px with no border at all: the crop upstream's packaging never
  # applied. hicolor declares 512x512 and GTK scales it per context, which is
  # already how every icon shipped as a single large PNG behaves.
  artifact "claude-desktop-unofficial-512.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/claude-desktop-unofficial.png"

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

    # Why a copy rather than an artifact pointed straight at resources/icon.png:
    # `artifact` MOVES its source out of the payload, and the app reads that file
    # at runtime — it is the BrowserWindow icon, loaded through
    # nativeImage.createFromPath — so moving it would buy a correct launcher at
    # the price of a window with no icon. This copy is what gets moved out.
    copy "usr/lib/claude-desktop-unofficial/resources/icon.png",
         "claude-desktop-unofficial-512.png"

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
