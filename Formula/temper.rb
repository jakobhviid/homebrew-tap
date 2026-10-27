class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.9.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.9.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5dcbb5d1e8b2493b71623dad212cf7a3442e1b260a8fd854a3740c3f2fb01ef0"
    sha256 cellar: :any_skip_relocation, tahoe: "b9ebff415b79bcb6164f3abc8fdcc6b85590dfc9c624af6728ac65270cdbe5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2e2f33f66e7fce5c0339eb9194e5031dc6826819408375e87302f78b2a62c7ab"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "f469d3295a6b1fc90b64690897e1a6f1fd11c1449b8ead22a61fb58e6df4bb91"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9ac7040ff76f04b3abec104f4e66eb39127660f3f0789c5ade61e89e5e01f104"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f9b85dc223bf129777fcc86e90e1fd564843352ba8d091c0bccbd99129c05a38"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "426389093d7507da6106be3c5834ed260a8ab8441598bccc9fab35f0f71b2e6f"
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
