class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "bdf7799793e97939d1196abf53d026f1d5a22eea3d7be051102b13e6792ae91a"
    sha256 cellar: :any_skip_relocation, tahoe: "86e8127851a8499eb2693e8da0ad6d73fdb859210273c25db9fb5655165cf594"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9af5f2b712be8d35522eca1241ea4a1bc744356528b65fbf57b4363b2b82fced"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "7861edfe447a9a6b34c51a6d28ca55218190151b94d8bcf8377ebfb311b254cf"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ab19b7cec314e1b9d4d47a27717f47185f21c04a3f0cd786ecfbd7a101d9eb81"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0c4ff597d2f22effe2f74a41b8ba99ec387caf64cfd9dae14995753fc32be03c"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d1afa748ea94c9173a133e2045d207cd2e823096950e6c75d2b6d9b86d138acd"
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
