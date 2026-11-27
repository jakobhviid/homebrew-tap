cask "verso" do
  # Why one cask for both systems: `brew install --cask jakobhviid/tap/verso` is the one command on either. Each part
  # has a version of its own, as a release carries the Mac only when it was built for it.
  on_macos do
    version "0.77.0"
    sha256 "2257e44ed1ba60bfbd09c66d266ae3d3a390f7de69a540a61db254d092d16a99"

    # The notarized universal app, one disk image for Apple silicon and Intel.
    url "https://github.com/jakobhviid/verso/releases/download/v#{version}/verso-#{version}.dmg"

    # Why: the app updates itself (Sparkle, from Verso's page's signed feed), so `brew upgrade` leaves it be.
    auto_updates true
    depends_on macos: :sequoia

    app "Verso.app"

    caveats <<~EOS
      Open Verso and sign in to your Immich server. Verso Drive, your library
      in Finder's sidebar, comes once you switch it on in Settings.

      Verso is an independent, unofficial project, not affiliated with the
      Immich project or FUTO.
    EOS
  end
  on_linux do
    version "0.77.0"
    sha256 "8836c792d618cedee720918fe16122c1d7d0883577d1e3be44140bd1599d9f1a"

    url "https://github.com/jakobhviid/verso/releases/download/v#{version}/verso-x86_64.tar.gz"

    # Why x86_64 and GNOME 49's libraries: it is built in a Fedora 44 toolbox and links the system's GTK 4 (4.18 at
    # least) and libadwaita (1.8 at least). bin/verso is a script that checks the system's libadwaita first and says
    # why on an older one, as the window binds every symbol as it loads and the loader would stop it unseen; it then
    # runs the window, libexec/verso. The map's library (libshumate), which a desktop may not have, comes with it in
    # libexec/lib/, beside the window's program that finds it there.
    depends_on arch: :x86_64

    binary "verso/verso"
    binary "verso/verso-service"
    artifact "verso/dev.hviid.Verso.desktop",
             target: "#{Dir.home}/.local/share/applications/dev.hviid.Verso.desktop"
    # The app's icon at each size, and its symbolic one.
    artifact "verso/hicolor/16x16/apps/dev.hviid.Verso.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/16x16/apps/dev.hviid.Verso.png"
    artifact "verso/hicolor/32x32/apps/dev.hviid.Verso.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/32x32/apps/dev.hviid.Verso.png"
    artifact "verso/hicolor/64x64/apps/dev.hviid.Verso.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/64x64/apps/dev.hviid.Verso.png"
    artifact "verso/hicolor/128x128/apps/dev.hviid.Verso.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/128x128/apps/dev.hviid.Verso.png"
    artifact "verso/hicolor/256x256/apps/dev.hviid.Verso.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/256x256/apps/dev.hviid.Verso.png"
    artifact "verso/hicolor/512x512/apps/dev.hviid.Verso.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/dev.hviid.Verso.png"
    artifact "verso/hicolor/symbolic/apps/dev.hviid.Verso-symbolic.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/dev.hviid.Verso-symbolic.svg"
    # The top bar icon's states: in the desktop's one colour, and in colour (Preferences, General, Colour).
    artifact "verso/hicolor/symbolic/apps/dev.hviid.Verso-offline-symbolic.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/dev.hviid.Verso-offline-symbolic.svg"
    artifact "verso/hicolor/symbolic/apps/dev.hviid.Verso-signed-out-symbolic.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/dev.hviid.Verso-signed-out-symbolic.svg"
    artifact "verso/hicolor/symbolic/apps/dev.hviid.Verso-unmounted-symbolic.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/dev.hviid.Verso-unmounted-symbolic.svg"
    artifact "verso/hicolor/scalable/apps/dev.hviid.Verso-tray.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/dev.hviid.Verso-tray.svg"
    artifact "verso/hicolor/scalable/apps/dev.hviid.Verso-tray-offline.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/dev.hviid.Verso-tray-offline.svg"
    artifact "verso/hicolor/scalable/apps/dev.hviid.Verso-tray-signed-out.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/dev.hviid.Verso-tray-signed-out.svg"
    artifact "verso/hicolor/scalable/apps/dev.hviid.Verso-tray-unmounted.svg",
             target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/dev.hviid.Verso-tray-unmounted.svg"
    # Verso Drive's own icon, the app's with a drive's badge, for the drive in a dock, Files and Show in.
    artifact "verso/hicolor/16x16/apps/dev.hviid.Verso.Drive.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/16x16/apps/dev.hviid.Verso.Drive.png"
    artifact "verso/hicolor/32x32/apps/dev.hviid.Verso.Drive.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/32x32/apps/dev.hviid.Verso.Drive.png"
    artifact "verso/hicolor/64x64/apps/dev.hviid.Verso.Drive.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/64x64/apps/dev.hviid.Verso.Drive.png"
    artifact "verso/hicolor/128x128/apps/dev.hviid.Verso.Drive.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/128x128/apps/dev.hviid.Verso.Drive.png"
    artifact "verso/hicolor/256x256/apps/dev.hviid.Verso.Drive.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/256x256/apps/dev.hviid.Verso.Drive.png"
    artifact "verso/hicolor/512x512/apps/dev.hviid.Verso.Drive.png",
             target: "#{Dir.home}/.local/share/icons/hicolor/512x512/apps/dev.hviid.Verso.Drive.png"
    # Verso Drive's menu in Files (Open in Immich, Copy Immich Link, Show in other apps), for nautilus-python.
    artifact "verso/verso-nautilus.py",
             target: "#{Dir.home}/.local/share/nautilus-python/extensions/verso-nautilus.py"

    # Why %u stays: the browser sign-in's redirect (app.immich:) and crosslink links reach the app as its argument.
    preflight_steps do
      inreplace "verso/dev.hviid.Verso.desktop",
                /^Exec=.*$/,
                "Exec={{HOMEBREW_PREFIX}}/bin/verso %u"
    end

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

    zap trash: [
      "~/.cache/verso",
      "~/.config/systemd/user/default.target.wants/verso.service",
      "~/.config/systemd/user/gvfs-udisks2-volume-monitor.service.d/verso.conf",
      "~/.config/systemd/user/verso.service",
      "~/.config/verso",
      "~/.local/share/applications/dev.hviid.Verso.Drive.desktop",
      "~/.local/share/applications/dev.hviid.Verso.Gallery.desktop",
      "~/.local/share/nautilus-python/extensions/__pycache__/verso-nautilus.*.pyc",
      "~/.local/share/verso",
      "~/.local/state/verso",
    ]

    caveats <<~EOS
      An evaluation build. Open Verso from the app grid and sign in; where Immich
      Mount is signed in, it offers that account. Its service then runs the tray
      from login, and the drive once you switch it on in Preferences, Verso Drive.
      On GNOME the tray needs the AppIndicator extension.

      Verso needs GNOME 49's libraries or newer (libadwaita 1.8 and GTK 4.18):
      Fedora 43 and newer, Ubuntu 25.10 and 26.04 LTS, Debian 14, Arch and other
      rolling distributions. On an older system (Ubuntu 24.04 and what is built
      on it, Debian 13, Fedora 42) Verso says so when it starts; its Flatpak,
      verso-x86_64.flatpak on the releases page, runs there, without Verso Drive.

      Verso is an independent, unofficial project, not affiliated with the Immich
      project or FUTO.
    EOS
  end

  name "Verso for Immich"
  desc "Gallery, drive and tray for an Immich photo library (unofficial)"
  homepage "https://jakob.hviid.phd/verso/"

  livecheck do
    url "https://github.com/jakobhviid/verso"
    strategy :github_latest
  end
end
