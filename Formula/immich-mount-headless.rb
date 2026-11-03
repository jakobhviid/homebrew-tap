# Immich Mount without the app, for a server or a session with no desktop. A desktop installs the cask
# `immich-mount` instead, which is the whole app and has the same daemon in it; the two do not go together.
class ImmichMountHeadless < Formula
  desc "Immich photos and videos as a drive, without the desktop app (unofficial)"
  homepage "https://github.com/jakobhviid/immich-mount"
  # Linux-only (FUSE), but Homebrew needs a url on EVERY platform just to parse the formula: with the url only
  # inside `on_linux`, macOS sees an empty spec and every `brew` command errors. So x86_64 Linux is the top-level
  # default, and `depends_on :linux` is what keeps macOS from installing it.
  url "https://github.com/jakobhviid/immich-mount/releases/download/v1.4.2/immich-mount-x86_64-unknown-linux-musl.tar.gz"
  version "1.4.2"
  sha256 "b4bf41bb22117f1dd489e196b66b87ba0863b0cff9068d74e8083573f19de8a2"
  license "MIT"

  # A prebuilt x86_64 Linux bottle, so `brew install` pours it; aarch64 uses the url and install below.
  bottle do
    root_url "https://github.com/jakobhviid/immich-mount/releases/download/v1.4.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "188eddecf28ed1c6dc0bb9e74b880c18cca843703fe97708adca5d422effe236"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/immich-mount/releases/download/v1.4.2/immich-mount-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0adc50c372dec43ac4db73c7389e606c747c60ad84302c355bb89cc2135fdc17"
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
