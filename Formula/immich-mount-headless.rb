# Immich Mount without the app, for a server or a session with no desktop. A desktop installs the cask
# `immich-mount` instead, which is the whole app and has the same daemon in it; the two do not go together.
class ImmichMountHeadless < Formula
  desc "Immich photos and videos as a drive, without the desktop app (unofficial)"
  homepage "https://github.com/jakobhviid/immich-mount"
  # Linux-only (FUSE), but Homebrew needs a url on EVERY platform just to parse the formula: with the url only
  # inside `on_linux`, macOS sees an empty spec and every `brew` command errors. So x86_64 Linux is the top-level
  # default, and `depends_on :linux` is what keeps macOS from installing it.
  url "https://github.com/jakobhviid/immich-mount/releases/download/v1.3.7/immich-mount-x86_64-unknown-linux-musl.tar.gz"
  version "1.3.7"
  sha256 "e01d159b7f736b5c865f5c52645998bdd0f7ffb208ca7c7fb7e2bb868b18f05d"
  license "MIT"

  # A prebuilt x86_64 Linux bottle, so `brew install` pours it; aarch64 uses the url and install below.
  bottle do
    root_url "https://github.com/jakobhviid/immich-mount/releases/download/v1.3.7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c085e4578ca2c5ed1ccc153b95621bc336635303363fd2c0772dfe4b9ca88672"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/immich-mount/releases/download/v1.3.7/immich-mount-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ea1956bccca6100f027e6fd0bbede92357496db87f72eab049ef47d2904b9e6c"
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
