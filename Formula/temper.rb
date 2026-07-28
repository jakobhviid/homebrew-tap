class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.26.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.26.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "206141f66790985afe9e8066c2d110992067e92720e6fe554938327c7ce3fa0a"
    sha256 cellar: :any_skip_relocation, tahoe: "f1c4a8508f92344be46b1fb1676b1a6b234d0e7e7648be2417276c90139076a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be703e1b66dd98bd7c6395362f5424563f4995fe71386bff2c7dcd07bdeed8d4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "55bcf78c2c0f7afbd9e1310ffc5a41aa760356674abb133d108b566003017212"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "01356611f759c8bf28144254fb58709802ecf82cea2d870ff5f8d6df87167860"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "150d24d5a5b828cdf55ba1230f160661024f7f03d5b60d5b7df1fe7972adf6df"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.26.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c617271cab56dff1d29d75fd8568c1c8ed55eebdd069c3cee6b85ae665d3f173"
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
