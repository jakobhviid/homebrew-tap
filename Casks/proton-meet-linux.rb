cask "proton-meet-linux" do
  version "1.0.10"
  sha256 x86_64_linux: "df9154d2db55e70c8d9eb87a4e61153352c8ee45d041bae7ea98fa7054596d5c"

  url "https://proton.me/download/meet/linux/#{version}/ProtonMeet-desktop.rpm"
  name "Proton Meet"
  desc "End-to-end encrypted video conferencing"
  homepage "https://proton.me/meet"

  # Why: Proton publishes no yum repo for the desktop apps — the only official
  # Linux path is a direct .rpm from proton.me, resolved through this feed. Only
  # Proton VPN gets a real Proton-operated repo. Stable, not EarlyAccess: the
  # desktop updaters measure themselves against the Stable feed regardless of the
  # webapp's Beta-access toggle, so an EarlyAccess build sits permanently
  # "behind" and shows a standing in-app update banner.
  livecheck do
    url "https://proton.me/download/meet/linux/version.json"
    strategy :json do |json|
      json["Releases"]&.select { |r| r["CategoryName"] == "Stable" }&.map { |r| r["Version"] }
    end
  end

  # Why: the payload is a glibc x86_64 RPM. Proton ships no arm64 Linux build,
  # so refuse to install rather than staging a payload that cannot run.
  depends_on linux: :any
  depends_on arch: :x86_64

  # Why: the RPM's own /usr/bin entry is a RELATIVE symlink into
  # ../lib/proton-meet/, so it keeps resolving inside the Caskroom once staged and
  # Homebrew's bin symlink resolves through it to the real Electron binary.
  # Pointing at "Proton Meet Beta" directly would work too but would hardcode a name
  # that carries upstream's "Beta" suffix on some apps and not others.
  binary "usr/bin/proton-meet"
  artifact "usr/share/applications/proton-meet.desktop",
           target: "#{Dir.home}/.local/share/applications/proton-meet.desktop"
  # Why two icons: Meet is the one app in the suite that ships a proper hicolor
  # set rather than a mislabelled pixmap. Install both the raster and the
  # scalable form so GNOME can pick per context instead of downscaling one PNG.
  artifact "usr/share/icons/hicolor/256x256/apps/proton-meet.png",
           target: "#{Dir.home}/.local/share/icons/hicolor/256x256/apps/proton-meet.png"
  artifact "usr/share/icons/hicolor/scalable/apps/proton-meet.svg",
           target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/proton-meet.svg"

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

    # Why: upstream ships `Exec=proton-meet %U`, a bare command resolved through
    # PATH — and GNOME's PATH does not include the Homebrew prefix, so the
    # launcher would do nothing while the terminal worked fine. Point it at the
    # bin symlink, which is stable across version bumps, and keep %U so the
    # app still receives the URL it is handed.
    inreplace "usr/share/applications/proton-meet.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/proton-meet %U"
  end

  # Why: without a database refresh the launcher only appears after the next
  # login. `must_succeed: false` keeps the step a no-op where the tool is not
  # shipped, and the paths are reached through `chdir` because a step argument
  # expands `{{...}}` tokens but not `~`.
  postflight_steps do
    run "update-desktop-database",
        args:         ["."],
        chdir:        "~/.local/share/applications",
        must_succeed: false
    run "gtk-update-icon-cache",
        args:         ["-f", "-t", "."],
        chdir:        "~/.local/share/icons/hicolor",
        must_succeed: false
  end

  uninstall_postflight_steps do
    run "update-desktop-database",
        args:         ["."],
        chdir:        "~/.local/share/applications",
        must_succeed: false
    run "gtk-update-icon-cache",
        args:         ["-f", "-t", "."],
        chdir:        "~/.local/share/icons/hicolor",
        must_succeed: false
  end

  # Why this path: Electron derives userData from productName, and Mail — the one
  # app in the suite far enough along to have created it — uses "Proton Mail"
  # with the space and without the binary's "Beta" suffix. This follows that
  # observed convention rather than the binary name.
  zap trash: [
    "~/.cache/Proton Meet",
    "~/.config/Proton Meet",
  ]

  caveats <<~EOS
    Homebrew owns this install's version. Upgrade with:
      brew upgrade --cask proton-meet-linux

    Proton Meet is Electron, so it links against a desktop runtime (GTK 3, NSS,
    cups, ALSA) that Homebrew cannot supply. A desktop install already has it.

    The bundled chrome-sandbox is not setuid here, matching upstream's own RPM:
    Electron uses the unprivileged user-namespace sandbox instead, which needs
    user.max_user_namespaces > 0. Fedora and Bazzite enable it by default.
  EOS
end
