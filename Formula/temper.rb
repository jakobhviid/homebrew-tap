class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "19ffd64b25d7c020e47b10f2bf97c7a445af5f56bc4df4458c771d0e37955679"
    sha256 cellar: :any_skip_relocation, tahoe: "76a0cbe0037214b1a254bb138abaf3257ff9136000a4be24be690aba1c19d009"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "504a163faf0a0a7505f56045331852447c36aec3acabb44d9335ce14b147797e"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "5111ee7c93e296b88d592e8ea0c68580f8cee174fd722ed09616c831974ec1d8"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "310e83f010cff91ac86454ae2e4c3dcfb4713c95290575f418db2f7b95db9309"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "86c49cd5a23c99e7d0692d2e564586507b079cdff7df7cae81d7bda0d63de88e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c38a76d8eeca2dd73e05f0b0744da5afe1bf1e0198c25325c788587b273a1fea"
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
