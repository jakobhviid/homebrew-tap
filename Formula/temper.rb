class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.29.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.29.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e5630eacb2a15b168fdaa3049c25ae0fd0aa6f3962f8d5da49694a0d9c519c58"
    sha256 cellar: :any_skip_relocation, tahoe: "ee58a0c957fa51bda63ac478676b01870ccbf70c6cbf178bfca72ded6f6821a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff6e2d75185485f05c0f96b4276bedfe93e811e0148d81897355b4041ca7da8d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "e778be44a1c0751513d964efe779787a76532bd65e455d23da56c882c7fc6043"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "13601c37bd61f4a3bc11eb22f9ed35ab589ff7d0eb83ee1e72ee4d4645383bb7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f9fad53e33d287cdeacf293f298e36678c3dcbabf40c7dd867c5e99cf5a88cea"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "22373ce53f29d30f7de36a8baaad00ed4dd1c9bf265b7b7222801774894a304d"
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
