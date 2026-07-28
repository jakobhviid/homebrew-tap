class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.29.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.29.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "02540c61111cdcfb9142210e7873f242cfe6bf7e7253105cb103b926a1cafc07"
    sha256 cellar: :any_skip_relocation, tahoe: "1fbe847c4c1e77e965c3db05795d50bb4cb373580661fcbac9c7872a3376078d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "546e1eaa8db83869aed6aacc123554cf409c66ce25c772babb5bc0254c105abc"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c0c3eb6b91a31fd8408a1c96e07bf69cec268be804a0259305e29dd392c7df22"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d1181d8b3cda0f0fd9385f045cf756481f2a7571e8c2ab37b2221baf25cf6b82"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1a1af5037e18cfe0e840ea34b15c04d3c5b2e8320bb9f48d9ac9175cf5ce76d1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b59b10e82e38bc643d818b20e94121729dbdcb5e3a8f12b6f78ca92bcd06727e"
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
