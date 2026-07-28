class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.31.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.31.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9ff5665c80458581b78bbc18c4cf2fed2e8ee3048a522d0196149986c3a41a43"
    sha256 cellar: :any_skip_relocation, tahoe: "a0b7702a77c2fa4701eac5febc10b076f7af6366da4d753ab83fefd19e20e2e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9736763f3448212955fd8c2762fd3ef5c1b8d9e88484e63375f7367eb734110"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "728c01c5139f5bce0f2cfbed965e8db8fd93d03b51bbc3b15ca3a594f72d65eb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "993afa5a01a76b860c2d6cd099049d847e56fa644613012aa1f1dc27d831e409"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "29e56a525b4133f53533326f4cbcf24847e85c1ee82c6297430cda02657a404a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5dc2c238a649ffe6e27a503b25328444f5abf4904d8cdbb97eb9e8af7db1bb86"
    end
  end

  def install
    bin.install "temper"
    generate_completions_from_executable(bin/"temper", "completions")
    (man1/"temper.1").write Utils.safe_popen_read(bin/"temper", "--man")
  end

  test do
    assert_match "temper", shell_output("#{bin}/temper --help")
  end
end
