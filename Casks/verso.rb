cask "verso" do
  version "0.5.14"
  sha256 "d93842694db9da77fb7930cb229ac79e7dcb97f5fb928a871a96409d1314437a"

  # Why a releases-only repository: the source is private while the app is evaluated; the builds are public.
  url "https://github.com/jakobhviid/verso-releases/releases/download/v#{version}/verso-x86_64.tar.gz"
  name "Verso for Immich"
  desc "Gallery, drive and tray for an Immich photo library (evaluation build)"
  homepage "https://github.com/jakobhviid/verso-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why x86_64 and Fedora 44's libraries: it is built in Immich Mount's Fedora 44 toolbox and links the system's GTK 4
  # and libadwaita, as Immich Mount's own cask does. The map's library (libshumate), which a desktop may not have,
  # comes with it in lib/, beside the window's program that finds it there.
  depends_on arch: :x86_64
  depends_on linux: :any

  binary "verso/verso"
  binary "verso/verso-service"
  artifact "verso/dev.hviid.Verso.desktop",
           target: "#{Dir.home}/.local/share/applications/dev.hviid.Verso.desktop"
  # The Mac app's icon at each size, and its menu bar icon as the symbolic one.
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

    Verso is an independent, unofficial project, not affiliated with the Immich
    project or FUTO.
  EOS
end
