class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.26.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.26.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5d7be3b9dfbee6e95092550ba6ec9868656afaac44532c47ce404cfae1b2300e"
    sha256 cellar: :any_skip_relocation, tahoe: "c2d5682c6f7c6d6f4f63e613a7824c9f633f0a41c0d4c8f5d667f2c7b623b636"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2edfe7bb4a18edf6c4438c2561590e7408d540449451d13381dcd3d50a9e2023"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "e386587db6b22cf7493e5b48db41174bf3ce08e9a8c635b1cb18729a13e1563b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "0df27e9e8ec0498115f9b197a202c70c5a552334bffb93886c2a9ff66a2c0bce"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "da8607b36cfd26726ea9ce6366f3c3e6496cf3c9eabe71df71f37f97afb07140"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1ead8422d8d27a364264bb5d94672462c70da81cf90bf074b770fec2ca8b120d"
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
