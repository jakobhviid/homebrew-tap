cask "immich-mount" do
  version "2.33.1"
  sha256 arm:          "6a4fa69dca844bb8e80dffcfd8525cd06358068d98fa9bac5a282ebfe596126e",
         intel:        "6a4fa69dca844bb8e80dffcfd8525cd06358068d98fa9bac5a282ebfe596126e",
         x86_64_linux: "c05454787fa3438aa488f0fa0dff95e1d31f5a764ad7bef20975b64aa85b22c5"

  # Why one cask for both systems: `brew install jakobhviid/tap/immich-mount` is the one command on either, and both
  # carry the same version, from the same release.
  on_macos do
    # The notarized universal app, one disk image for Apple silicon and Intel.
    url "https://github.com/jakobhviid/immich-mount/releases/download/v#{version}/immich-mount-#{version}.dmg"

    # Why: the app updates itself (Sparkle, from the download page's signed feed), so `brew upgrade` leaves it be.
    auto_updates true
    depends_on macos: :sonoma

    app "Immich Mount.app"

    # Why the script: macOS runs nothing when an app is deleted, and keeps a provider's Finder location until the app
    # removes it, so the app signs out first, once quit (`Immich Mount --uninstall`), and its location leaves Finder
    # with it. Only an app whose Info.plist says it can (ImmichMountUninstall): an older one would ignore the argument
    # and start, and the uninstall would wait on it.
    uninstall quit:   "dev.hviid.ImmichMount",
              script: {
                executable:   "/bin/sh",
                args:         [
                  "-c",
                  "/usr/libexec/PlistBuddy -c 'Print :ImmichMountUninstall' \"$1/Contents/Info.plist\" " \
                  ">/dev/null 2>&1 || exit 0; exec \"$1/Contents/MacOS/Immich Mount\" --uninstall",
                  "sh",
                  "#{appdir}/Immich Mount.app",
                ],
                must_succeed: false,
              }

    # Why these: the app and its Finder extension are sandboxed, so all they keep is in their containers and the
    # team's App Group (the sign-in, the settings, the extension's store).
    zap trash: [
      "~/Library/Application Scripts/dev.hviid.ImmichMount",
      "~/Library/Application Scripts/dev.hviid.ImmichMount.FileProvider",
      "~/Library/Application Scripts/G79YT9UUAL.dev.hviid.ImmichMount",
      "~/Library/Containers/dev.hviid.ImmichMount",
      "~/Library/Containers/dev.hviid.ImmichMount.FileProvider",
      "~/Library/Group Containers/G79YT9UUAL.dev.hviid.ImmichMount",
    ]

    caveats <<~EOS
      Open Immich Mount from Applications and sign in, then click Enable at the
      top of its Finder window, as the app shows. It lives in the menu bar, and
      your library in Finder's sidebar.

      brew uninstall signs it out first, so its location leaves Finder too.

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
    # Why in Dolphin: KIO finds plugins only on Qt's plugin path. A link, so the plugin finds its translations beside
    # its real file, in a folder that holds only it; the Plasma login script puts that folder on QT_PLUGIN_PATH, so
    # Dolphin offers the items from the next login.
    binary "immich-mount-dolphin.so",
           target: "#{Dir.home}/.local/lib/immich-mount/plugins/kf6/kfileitemaction/immich-mount-dolphin.so"
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
    # Why Open in Immich comes this way in Files: Nautilus loads C extensions only from its folder in /usr, read-only
    # on Bazzite and the atomic desktops, while nautilus-python, which they ship, loads from the home folder
    # (GSConnect installs itself the same way). It stays quiet where the packages' C extension is installed.
    artifact "immich-mount-nautilus.py",
             target: "#{Dir.home}/.local/share/nautilus-python/extensions/immich-mount-nautilus.py"
    # The Plasma login script that puts the plugin's folder on QT_PLUGIN_PATH (above).
    artifact "immich-mount-plasma-env.sh",
             target: "#{Dir.home}/.config/plasma-workspace/env/immich-mount.sh"

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
      "~/.local/lib/immich-mount",
      "~/.local/share/nautilus-python/extensions/__pycache__/immich-mount-nautilus.*.pyc",
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
