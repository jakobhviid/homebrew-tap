cask "proton-mail-linux" do
  version "1.14.0"
  sha256 "6c429e8d94ea57da24b83a49cbe98ce3f37f11d72b4dc0e314a473ce7d03c4b0"

  url "https://proton.me/download/mail/linux/#{version}/ProtonMail-desktop-beta.rpm"
  name "Proton Mail"
  desc "Encrypted email client"
  homepage "https://proton.me/mail"

  # Why: Proton publishes no yum repo for the desktop apps — the only official
  # Linux path is a direct .rpm from proton.me, resolved through this feed. Only
  # Proton VPN gets a real Proton-operated repo. Stable, not EarlyAccess: the
  # desktop updaters measure themselves against the Stable feed regardless of the
  # webapp's Beta-access toggle, so an EarlyAccess build sits permanently
  # "behind" and shows a standing in-app update banner.
  livecheck do
    url "https://proton.me/download/mail/linux/version.json"
    strategy :json do |json|
      json["Releases"]&.select { |r| r["CategoryName"] == "Stable" }&.map { |r| r["Version"] }
    end
  end

  # Why: the payload is a glibc x86_64 RPM. Proton ships no arm64 Linux build,
  # so refuse to install rather than staging a payload that cannot run.
  depends_on arch: :x86_64
  depends_on linux: :any

  # Why: the RPM's own /usr/bin entry is a RELATIVE symlink into
  # ../lib/proton-mail/, so it keeps resolving inside the Caskroom once staged and
  # Homebrew's bin symlink resolves through it to the real Electron binary.
  # Pointing at "Proton Mail Beta" directly would work too but would hardcode a name
  # that carries upstream's "Beta" suffix on some apps and not others.
  binary "usr/bin/proton-mail"
  artifact "usr/share/applications/proton-mail.desktop",
           target: "#{Dir.home}/.local/share/applications/proton-mail.desktop"
  # Why installed as .svg: upstream ships this icon at /usr/share/pixmaps/
  # proton-mail.png and the file is actually an SVG — a packaging bug on
  # Proton's side. Renaming it on the way in lets the icon theme index it, which
  # it will not do for an SVG named .png, and puts it where Icon=proton-mail
  # resolves. It is also the only icon the RPM ships; there is no hicolor set.
  artifact "usr/share/pixmaps/proton-mail.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/proton-mail.svg"

  preflight_steps do
    # Why rpm2cpio and not bsdtar: bsdtar is NOT installed on Bazzite (checked
    # 2026-09-08), so a libarchive-based extraction fails on the exact platform
    # this cask targets. And not rpm2archive either — its interface is not
    # stable across rpm versions: rpm 6 streams to stdout and creates no .tgz,
    # while older releases wrote FILE.tgz and printed nothing, so a pipeline
    # built on it silently extracts an empty archive on one of the two.
    # rpm2cpio has written cpio to stdout for decades and ships with rpm itself.
    # A pipeline needs a shell, so it runs through /bin/sh, and the glob names
    # the staged RPM: its filename is upstream's, not derived from `version`.
    # A `run` step raises on a non-zero exit, so a failed extraction aborts the
    # install instead of leaving a half-filled tree for the artifacts.
    run "/bin/sh",
        args:  ["-c", "rpm2cpio ./*.rpm | cpio -idmu --quiet"],
        chdir: "{{staged_path}}"

    # Why: the extracted tree is the install; keeping the ~100 MB RPM as well
    # would double the Caskroom footprint for no benefit.
    remove "*.rpm"

    # Why: upstream ships `Exec=proton-mail %U`, a bare command resolved through
    # PATH — and GNOME's PATH does not include the Homebrew prefix, so the
    # launcher would do nothing while the terminal worked fine. Point it at the
    # bin symlink, which is stable across version bumps, and keep %U so the
    # app still receives the URL it is handed.
    inreplace "usr/share/applications/proton-mail.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/proton-mail %U"
  end

  # Why: without a database refresh the launcher only appears after the next
  # login. `must_succeed: false` keeps the step a no-op where the tool is not
  # shipped.
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

  # Why "Proton Mail" and NOT "protonmail": both directories exist on a machine
  # that has run the suite, and they belong to different products.
  # ~/.config/Proton Mail is this app's Electron userData (verified: it holds
  # blob_storage and Code Cache). ~/.config/protonmail, ~/.cache/protonmail and
  # ~/.local/share/protonmail all hold `bridge-v3` — Proton Mail BRIDGE's data.
  # Zapping those would destroy a different application's configuration, so they
  # are deliberately absent from this list.
  zap trash: [
    "~/.cache/Proton Mail",
    "~/.config/Proton Mail",
  ]

  caveats <<~EOS
    Homebrew owns this install's version. Upgrade with:
      brew upgrade --cask proton-mail-linux

    Proton Mail is Electron, so it links against a desktop runtime (GTK 3, NSS,
    cups, ALSA) that Homebrew cannot supply. A desktop install already has it.

    The bundled chrome-sandbox is not setuid here, matching upstream's own RPM:
    Electron uses the unprivileged user-namespace sandbox instead, which needs
    user.max_user_namespaces > 0. Fedora and Bazzite enable it by default.
  EOS
end
