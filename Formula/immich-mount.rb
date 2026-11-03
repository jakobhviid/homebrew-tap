class ImmichMount < Formula
  desc "Your Immich photos and videos as a drive in your file manager (unofficial)"
  homepage "https://github.com/jakobhviid/immich-mount"
  # Linux-only (FUSE), but Homebrew needs a url on EVERY platform just to parse the formula: with the url only
  # inside `on_linux`, macOS sees an empty spec and every `brew` command errors. So x86_64 Linux is the top-level
  # default, and `depends_on :linux` is what keeps macOS from installing it.
  url "https://github.com/jakobhviid/immich-mount/releases/download/v1.0.3/immich-mount-x86_64-unknown-linux-musl.tar.gz"
  version "1.0.3"
  sha256 "ca81e19fa6a0b9f078b1095fc027652414565eff00d4b9d9cac9c1a4e7c01b5b"
  license "MIT"

  # A prebuilt x86_64 Linux bottle, so `brew install` pours it; aarch64 uses the url and install below.
  bottle do
    root_url "https://github.com/jakobhviid/immich-mount/releases/download/v1.0.3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3ab3ffcdf603436a630ba7266c55f98c9875ee146088451046476e466e4fab35"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/immich-mount/releases/download/v1.0.3/immich-mount-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ccfbc65c2f0b0af8fb1e52dc7d80f98c057c84af78c52b83df97fae7c6780f07"
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
      For the GNOME or KDE app, use the .rpm or .deb packages on the GitHub releases instead of this
      formula: they bring their own daemon, and the app starts it at its first run.
      Immich Mount is an independent, unofficial project, not affiliated with the Immich project or FUTO.
    EOS
  end

  test do
    assert_match "immich-mount #{version}", shell_output("#{bin}/immich-mount --version")
  end
end
