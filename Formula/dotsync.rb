class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.3.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "eaac6eb1f5e506c13fca83f9e42dae75aeab23d49b4c4a50516956a868b53f32"
    sha256 cellar: :any_skip_relocation, tahoe: "71f9ee00ec1729525e2908769077a0f300058cfe7324af2e5402249c5f077883"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c120e7db17866abc27dcf6405d26bc6d3b63e36a0609c88f564315531697e183"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "448a912819a9668148e751e3407ce3c8dbf9269fbbfbbb4a9ecd1edb734edf2d"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "4c68c5f0e2c575fece6f23691818661fb38cc1c4bf0d4aea8b7cc7165ac1a002"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1eafc15c0af9db3ed7ddf155aace4ce09a837ce845b188ff6d0fd74337f6551b"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ad8bc03ea2e0fe524851253d30b5adf38cc8fe78b1ee10ec0d53f6c1387078ae"
    end
  end

  def install
    bin.install "dotsync"
    generate_completions_from_executable(bin/"dotsync", "completions")
    (man1/"dotsync.1").write Utils.safe_popen_read(bin/"dotsync", "man")
  end

  test do
    assert_match "dotsync", shell_output("#{bin}/dotsync --help")
  end
end
