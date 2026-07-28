class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.32.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.32.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ae54bb93a82a88290e7eaff3e61c4e4bb356a98e7f258e36cbaff5775fab2ed1"
    sha256 cellar: :any_skip_relocation, tahoe: "e0e22094acc6e5161f9f860af81a245284f971c858fa86b1cd5c2f0a56fb8ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00d3986b8f783ef7d31b088b0bb0611926395ef38433237f784bc09305628250"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "0c8fdca8b7641d8ba2fbe9ffe5543409c8254c5eb44f3fd0c640e9d166f5b77f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c4ca5fcdf3b7e24947d9a3a2eea312b0c062f30af10735aad390aeb1523d15a0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cca68f6d66171a02e78a3057ed386abc059cd7de1a67f1781979f2285dfd448f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5994450fb8ec780d571a9e21c7def7c99cb6703312eca4c95a3c5ff807ff949c"
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
