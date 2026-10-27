class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.8.8"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.8.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dfe6e0756ad7c85cce88e0435291f3b72b797ed5e454382c796fba7a165a7235"
    sha256 cellar: :any_skip_relocation, tahoe: "2a4325eb8ca402170d88596c4a50b7bc50ca9a1d9e525e1f7a368df022196828"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f990ff01e8ccefb5022ac77aa350c45ab71374af49b7ce981b5a10d859c80782"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.8/temper-x86_64-apple-darwin.tar.gz"
      sha256 "a493b9b7bfc10b01eb2048bfb62e59259c86a0bce35c5f0ee3d725425842df9f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.8/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c18384039efb0b349b4e36f2612e4dd7beae75f4953c3f67305000d1000531fd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.8/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1266ea4553eb0e38e51a9a3dca7498c2039fecea28b4512b849b865361dd09bc"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.8/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8a99f7a892c95eec3def42853a11b5d831e34d771e049f4376d2eed429704294"
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
