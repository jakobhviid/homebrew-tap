cask "immich-mount-linux" do
  version "1.1.1"
  sha256 "3aa3b783f9e56c1d78b28cbc2d3a8e80e1c0c485ef9a0745c4ca6aaf99dac20b"

  # The interfaces only: the daemon and the `immich-mount` launcher come from the formula this depends on. The
  # filename carries no version, so the release tag is the only part of the URL that moves.
  url "https://github.com/jakobhviid/immich-mount/releases/download/v#{version}/immich-mount-app-x86_64.tar.gz"
  name "Immich Mount"
  desc "Your Immich photos and videos as a drive in your file manager (unofficial)"
  homepage "https://github.com/jakobhviid/immich-mount"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why x86_64: the interfaces are built in the release's Fedora 44 job, which builds for x86_64 only.
  depends_on arch: :x86_64
  # Why the formula: its daemon serves the mount, and its `immich-mount app` is what the launcher runs, opening the
  # interface native to the desktop. The app's first run writes and starts the daemon's user service itself.
  depends_on formula: "jakobhviid/tap/immich-mount"
  depends_on linux: :any

  # Why both interfaces in one cask: `immich-mount app` opens Kirigami on KDE Plasma and GTK everywhere else, and on
  # a Plasma whose Qt this build does not load, GTK stands in. They link the system's own GTK, libadwaita and Qt.
  binary "immich-mount-gnome"
  binary "immich-mount-kde"
  # Why the release's desktop ID: it is the app ID both interfaces run under, so the shell matches their windows to
  # this launcher, and it declares the app.immich scheme the browser's sign-in redirect returns through.
  artifact "dev.hviid.ImmichMount.desktop",
           target: "#{Dir.home}/.local/share/applications/dev.hviid.ImmichMount.desktop"
  artifact "dev.hviid.ImmichMount.svg",
           target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/dev.hviid.ImmichMount.svg"
  # Why the symbolic icon too: the daemon's notifications carry it.
  artifact "dev.hviid.ImmichMount-symbolic.svg",
           target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/dev.hviid.ImmichMount-symbolic.svg"

  preflight_steps do
    # Why: the release's entry leaves where the launcher lives to the installer. Point it at the formula's bin
    # symlink, which is stable across version bumps, and keep `%u` so the app.immich redirect reaches the app.
    inreplace "dev.hviid.ImmichMount.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/immich-mount app %u"
  end

  # Why: without a database refresh the launcher only appears after the next login, and the app.immich scheme is
  # registered only once the MIME cache is rebuilt. The paths and `writable_paths` are spelled out as in the other
  # Linux casks here, for the same reasons: the steps run in Homebrew's sandbox, with its own empty $HOME.
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

  # Why not ~/.local/share/immich-mount: it keeps files that could not be uploaded, which are the user's.
  zap trash: [
    "~/.cache/immich-mount",
    "~/.config/immich-mount",
    "~/.config/systemd/user/immich-mount.service",
  ]

  caveats <<~EOS
    Open Immich Mount from the app grid: its first run signs you in and starts the mount.
    It opens in Kirigami on KDE Plasma and in GTK elsewhere.

    The interfaces are built on Fedora 44, so the system needs to be at least as new
    (GTK 4.18 and libadwaita 1.8). FUSE comes from your distribution's fuse3 package.

    Install this or the release's .rpm or .deb packages, not both.

    Immich Mount is an independent, unofficial project, not affiliated with the
    Immich project or FUTO.
  EOS
end
