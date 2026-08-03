class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3bc0ea20a9e9dd070f20fb3917406fb02f9cd6411f1982399ac079dcc5cd75cd"
    sha256 cellar: :any_skip_relocation, tahoe: "1e94fb8bce16b694f416e478a05cb8b34b5cf34132f9ac0e857dadc0b71b45bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5102c65f0f239a1fb4a6e9f8d519343ee7be8bda4b43b7d5f68cbab43fa8fa46"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.4/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "3129afb812ed98bca11552c168c6a0b0735abc64bf5f696da8605bbc8e418b46"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.4/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "29d4cb6ee8c6fbf44750170aa3eca72e6824d1d7af0807948cd607d1062241e9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.4/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ab494501268e3031a624543f4aa4057d151b113500a6cfd56ca1dc727c04e0a7"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.4/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3e8d1f94172ac60411a189cba62e6b0ed404c2e479f0c9b06ea2bf017d9edd9e"
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
