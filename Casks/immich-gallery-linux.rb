cask "immich-gallery-linux" do
  version "0.1.0"
  sha256 "a08ed077c630ddc6adffaff7b4d085c8c63d4de99fc9bb9c8941e484d557b6ad"

  # Why the API address and a token: the repository stays private while the app is evaluated, and GitHub serves a
  # private release's file only through its API, to a token that may read the repository (`gh auth token` gives one).
  # The asset's number changes with each release; the version in the query is for brew (GitHub ignores it).
  url "https://api.github.com/repos/jakobhviid/immich-gallery-linux/releases/assets/747367772?version=#{version}",
      header: [
        "Accept: application/octet-stream",
        "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}",
      ]
  name "Immich Gallery for Linux"
  desc "Gallery for an Immich photo library, beside Immich Mount (evaluation build)"
  homepage "https://github.com/jakobhviid/immich-gallery-linux"

  # Why no livecheck: the releases are private, so nothing outside can read the latest one.
  livecheck do
    skip "Private evaluation releases"
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
    An evaluation build from a private repository: brew downloads it with your
    GitHub token, so install and upgrade it with
      HOMEBREW_GITHUB_API_TOKEN=$(gh auth token) brew install jakobhviid/tap/immich-gallery-linux

    It shares Immich Mount's sign-in: signed in there, it opens signed in, and
    its Sign Out signs Immich Mount out too. "Immich Gallery" is a working name.
  EOS
end
