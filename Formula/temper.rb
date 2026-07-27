class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dcffd53e74a3525633d78a7bea5813e5133e180d3d6bd684b2b226632363cb11"
    sha256 cellar: :any_skip_relocation, tahoe: "e7eab40abb92daa9731a948adbc25a861c67b0d9e8fc809a977b598a1fc15590"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f874aea53dbcee6ea1906914d064f5136f0b8fe934a9c05567467c18dea7bec7"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "4a9f91ebdcc90c5cc19455956e5e7a4f48d0e88ebef785769d383955598ccc04"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "50db801b3a676ecce789f6bab51ff28e4b569c46c3cf91aef4f835b581d1d430"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "418d6c7c83ad73e55039b6da56228a1ffad2b0bb782036702e1732d6aeb764c2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7fe20a097fe2577cd3dfe5b3e9ffb4242b4c072e04106f6df802dc0c142815a2"
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
