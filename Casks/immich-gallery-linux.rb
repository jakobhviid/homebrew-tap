cask "immich-gallery-linux" do
  version "0.3.0"
  sha256 "c7fbbb90a1801637e7fd21d0f4402586b07169ea53432c274f3b02b7c1474943"

  # Why a releases-only repository: the source is private while the app is evaluated; the builds are public.
  url "https://github.com/jakobhviid/immich-gallery-linux-releases/releases/download/v#{version}/immich-gallery-linux-x86_64.tar.gz"
  name "Immich Gallery for Linux"
  desc "Gallery for an Immich photo library, beside Immich Mount (evaluation build)"
  homepage "https://github.com/jakobhviid/immich-gallery-linux-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Why x86_64 and Fedora 44's libraries: it is built in Immich Mount's Fedora 44 toolbox and links the system's GTK 4
  # and libadwaita, as Immich Mount's own cask does. The map's library (libshumate), which a desktop may not have,
  # comes with it in lib/, beside the binary that finds it there.
  depends_on arch: :x86_64
  depends_on linux: :any

  binary "immich-gallery-linux/immich-gallery-gnome"
  artifact "immich-gallery-linux/dev.hviid.ImmichGallery.desktop",
           target: "#{Dir.home}/.local/share/applications/dev.hviid.ImmichGallery.desktop"
  artifact "immich-gallery-linux/dev.hviid.ImmichGallery.svg",
           target: "#{Dir.home}/.local/share/icons/hicolor/scalable/apps/dev.hviid.ImmichGallery.svg"
  artifact "immich-gallery-linux/dev.hviid.ImmichGallery-symbolic.svg",
           target: "#{Dir.home}/.local/share/icons/hicolor/symbolic/apps/dev.hviid.ImmichGallery-symbolic.svg"

  preflight_steps do
    inreplace "immich-gallery-linux/dev.hviid.ImmichGallery.desktop",
              /^Exec=.*$/,
              "Exec={{HOMEBREW_PREFIX}}/bin/immich-gallery-gnome"
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

  zap trash: "~/.cache/immich-gallery"

  caveats <<~EOS
    An evaluation build. It shares Immich Mount's sign-in: signed in there, it
    opens signed in, and its Sign Out signs Immich Mount out too. "Immich
    Gallery" is a working name.
  EOS
end
