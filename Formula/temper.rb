class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.13.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.13.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4682563ea2bd7e5ced168c31fb13892d3e9a5dbe1db663346614e9b251bc9a8a"
    sha256 cellar: :any_skip_relocation, tahoe: "c90ba567480915c0f4de40c3b7e5dfe0e21fb989234a537005975908a1355d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0db7d8ddd55dfa9172f82aa650132bfb16b76a56dd23a71abc1c836452cb74b8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.13.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "cfd0979590c5399f4edbc8eb182287b0d12b2b93e9fabfe0c4bb58f304aee1fb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.13.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "dc3b5ba3c771a5f64e23562c0542034746d64db4ff3f78cc40a6fe25c0f2d04c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.13.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1c1a8c8e02df92ded4f7446448d5957477741cf445df80fda5242f00ef3e5195"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.13.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3fffd358b71ddce4364062be979aab62bfe4237b7fa094734936757d244500f1"
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
