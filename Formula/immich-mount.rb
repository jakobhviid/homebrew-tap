class ImmichMount < Formula
  desc "Your Immich photos and videos as a drive in your file manager (unofficial)"
  homepage "https://github.com/jakobhviid/immich-mount"
  # Linux-only (FUSE), but Homebrew needs a url on EVERY platform just to parse the formula: with the url only
  # inside `on_linux`, macOS sees an empty spec and every `brew` command errors. So x86_64 Linux is the top-level
  # default, and `depends_on :linux` is what keeps macOS from installing it.
  url "https://github.com/jakobhviid/immich-mount/releases/download/v1.0.2/immich-mount-x86_64-unknown-linux-musl.tar.gz"
  version "1.0.2"
  sha256 "5fe99bd9dc8177a9840a5fd6a246d2127e8f6c7e88bb818a974c1a77ebac87ac"
  license "MIT"

  # A prebuilt x86_64 Linux bottle, so `brew install` pours it; aarch64 uses the url and install below.
  bottle do
    root_url "https://github.com/jakobhviid/immich-mount/releases/download/v1.0.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "89d72a4efd5b3b7ae3b3763c1cc547eb8276ca9ca4916bdad73f7c125c33c778"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/immich-mount/releases/download/v1.0.2/immich-mount-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b7b4a30bc70c7fb84ad306a258bf0474de2adba8348fec5089313ca3ece653ee"
    end
  end

  def install
    bin.install "immich-mount"
    generate_completions_from_executable(bin/"immich-mount", "completions")
    (man1/"immich-mount.1").write Utils.safe_popen_read(bin/"immich-mount", "--man")
  end

  # `brew services start immich-mount` mounts at every login; an eject or `immich-mount unmount` exits cleanly and is
  # not restarted.
  service do
    run [opt_bin/"immich-mount", "daemon"]
    keep_alive crashed: true
  end

  def caveats
    <<~EOS
      Immich Mount needs FUSE from your distribution's fuse3 package:
        sudo dnf install fuse3      # or: sudo apt install fuse3
      Sign in, then mount it now and at every login:
        immich-mount login --server https://photos.example.org
        brew services start immich-mount
      The GNOME and KDE apps are .rpm and .deb packages on the GitHub releases.
      Immich Mount is an independent, unofficial project, not affiliated with the Immich project or FUTO.
    EOS
  end

  test do
    assert_match "immich-mount #{version}", shell_output("#{bin}/immich-mount --version")
  end
end
