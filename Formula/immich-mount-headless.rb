# Immich Mount without the app, for a server or a session with no desktop. A desktop installs the cask
# `immich-mount` instead, which is the whole app and has the same daemon in it; the two do not go together.
class ImmichMountHeadless < Formula
  desc "Immich photos and videos as a drive, without the desktop app (unofficial)"
  homepage "https://github.com/jakobhviid/immich-mount"
  # Linux-only (FUSE), but Homebrew needs a url on EVERY platform just to parse the formula: with the url only
  # inside `on_linux`, macOS sees an empty spec and every `brew` command errors. So x86_64 Linux is the top-level
  # default, and `depends_on :linux` is what keeps macOS from installing it.
  url "https://github.com/jakobhviid/immich-mount/releases/download/v1.3.6/immich-mount-x86_64-unknown-linux-musl.tar.gz"
  version "1.3.6"
  sha256 "c35859db1974354511c2d693fff2d79f73a33ff53bc539dc0b20b56bc805ccc8"
  license "MIT"

  # A prebuilt x86_64 Linux bottle, so `brew install` pours it; aarch64 uses the url and install below.
  bottle do
    root_url "https://github.com/jakobhviid/immich-mount/releases/download/v1.3.6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "73d8a9b01f85b112271b53871fc2fac42473699085f297de9ae2c61fc722b631"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/immich-mount/releases/download/v1.3.6/immich-mount-aarch64-unknown-linux-musl.tar.gz"
      sha256 "03c7ce35e62c961c2979d363f6c4b6bf54637b1f00b7c430bded719988b33403"
    end
  end

  def install
    bin.install "immich-mount"
    generate_completions_from_executable(bin/"immich-mount", "completions")
    (man1/"immich-mount.1").write Utils.safe_popen_read(bin/"immich-mount", "--man")
  end

  # For those who keep their services in Homebrew: `brew services start immich-mount-headless` mounts at every login,
  # as `immich-mount mount` does with a user unit of its own. An eject or `immich-mount unmount` exits cleanly and is
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
        immich-mount mount
      On a desktop, install the app instead, which has this in it:
        brew uninstall immich-mount-headless
        brew install jakobhviid/tap/immich-mount
      Immich Mount is an independent, unofficial project, not affiliated with the Immich project or FUTO.
    EOS
  end

  test do
    assert_match "immich-mount #{version}", shell_output("#{bin}/immich-mount --version")
  end
end
