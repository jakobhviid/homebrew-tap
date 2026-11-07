cask "immich-mount" do
  version "2.17.4"
  sha256 arm:          "685f7f02375453c597caf8be9ac9aae58dbe02b00d87b06a6b0fdda2fcb32b4e",
         intel:        "685f7f02375453c597caf8be9ac9aae58dbe02b00d87b06a6b0fdda2fcb32b4e",
         x86_64_linux: "61840dea765e493f9fb21533273779232a6121ca19833114cdc52b88b619d5b8"

  # Why one cask for both systems: `brew install jakobhviid/tap/immich-mount` is the one command on either, and both
  # carry the same version, from the same release.
  on_macos do
    # The notarized universal app, one disk image for Apple silicon and Intel.
    url "https://github.com/jakobhviid/immich-mount/releases/download/v#{version}/immich-mount-#{version}.dmg"

    # Why: the app updates itself (Sparkle, from the download page's signed feed), so `brew upgrade` leaves it be.
    auto_updates true
    depends_on macos: :sonoma

    app "Immich Mount.app"

    uninstall quit: "dev.hviid.ImmichMount"

    # Why these: the app and its Finder extension are sandboxed, so all they keep is in their containers and the
    # team's App Group (the sign-in, the settings, the extension's store). Sign out first, so Finder's location goes.
    zap trash: [
      "~/Library/Application Scripts/dev.hviid.ImmichMount",
      "~/Library/Application Scripts/dev.hviid.ImmichMount.FileProvider",
      "~/Library/Application Scripts/G79YT9UUAL.dev.hviid.ImmichMount",
      "~/Library/Containers/dev.hviid.ImmichMount",
      "~/Library/Containers/dev.hviid.ImmichMount.FileProvider",
      "~/Library/Group Containers/G79YT9UUAL.dev.hviid.ImmichMount",
    ]

    caveats <<~EOS
      Open Immich Mount from Applications and sign in, then switch it on once in
      System Settings, under General, Login Items & Extensions, File Providers.
      It lives in the menu bar, and your library in Finder's sidebar.

      Before uninstalling, sign out in its menu, so its location leaves Finder.

      Immich Mount is an independent, unofficial project, not affiliated with the
      Immich project or FUTO.
    EOS
  end
  on_linux do
    # The whole app: both interfaces, the static daemon and command line (also the launcher the desktop entry runs),
    # its man page and completions. The filename carries no version, so the release tag is the only part of the URL
    # that moves.
    # Why a cask named after the app, and no formula beside it: a desktop user installs it with
    # `brew install jakobhviid/tap/immich-mount`, one step, and no formula has that name for brew to pick instead.
    # Servers take the formula immich-mount-headless, the daemon alone; the two hold the same binary.
    url "https://github.com/jakobhviid/immich-mount/releases/download/v#{version}/immich-mount-app-x86_64.tar.gz"

    # Why x86_64: the interfaces are built in the release's Fedora 44 job, which builds for x86_64 only.
    depends_on arch: :x86_64

    # Why both interfaces in one cask: `immich-mount app` opens Kirigami on KDE Plasma and GTK everywhere else, and on
    # a Plasma whose Qt this build does not load, GTK stands in. They link the system's own GTK, libadwaita and Qt.
    binary "immich-mount-gnome"
    binary "immich-mount-kde"
    # Why the daemon here too: it serves the mount, and its `immich-mount app` is what the launcher runs, opening the
    # interface native to the desktop. The app's first run writes and starts the daemon's user service itself, from
    # this binary's stable link in Homebrew's bin.
    binary "immich-mount"
    manpage "immich-mount.1"
    bash_completion "immich-mount.bash"
    zsh_completion "_immich-mount"
    fish_completion "immich-mount.fish"
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
      # Why: the release's entry leaves where the launcher lives to the installer. Point it at Homebrew's bin symlink,
      # which is stable across version bumps, and keep `%u` so the app.immich redirect reaches the app.
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
    # Why trash, not delete, for the cache too: Homebrew deletes through sudo, which asks for an admin password to
    # remove the user's own files and fails without a display. `immich-mount logout` deletes the cache before an
    # uninstall. Why the link in default.target.wants: enabling the service made it, and alone it points at nothing.
    zap trash: [
      "~/.cache/immich-mount",
      "~/.config/immich-mount",
      "~/.config/systemd/user/default.target.wants/immich-mount.service",
      "~/.config/systemd/user/gvfs-udisks2-volume-monitor.service.d/immich-mount.conf",
      "~/.config/systemd/user/immich-mount.service",
    ]

    caveats <<~EOS
      Open Immich Mount from the app grid: its first run signs you in and starts the mount.
      It opens in Kirigami on KDE Plasma and in GTK elsewhere.

      The interfaces are built on Fedora 44, so the system needs to be at least as new
      (GTK 4.18 and libadwaita 1.8). FUSE comes from your distribution's fuse3 package.

      For a server without a desktop, use the formula immich-mount-headless instead.
      Install this or the release's .rpm or .deb packages, not both.

      Immich Mount is an independent, unofficial project, not affiliated with the
      Immich project or FUTO.
    EOS
  end

  name "Immich Mount"
  desc "Your Immich photos and videos as a drive in your file manager (unofficial)"
  homepage "https://jakob.hviid.phd/immich-mount/"

  livecheck do
    url "https://github.com/jakobhviid/immich-mount"
    strategy :github_latest
  end
end
