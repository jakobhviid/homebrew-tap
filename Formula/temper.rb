class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.32.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.32.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "caaf16a59d647b992c113ce9c0acbd531c9ece8ec9b9db975e9a0462acaf7d80"
    sha256 cellar: :any_skip_relocation, tahoe: "a30ebb2c0795fb89a1d606105c653beee18f7f382b66a29cd7e27f48fd9febd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6f0c59172ce2ede9de7f149361a64ccefce5efa39316ed0b702acc2d398128f4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3623ff5697783465d7fc440f2fce6e40545342bb9ce8c2924db23c2c7b917553"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1416e9f111ddc424cdf78cb3b4d19b0a379a13b5fd40baca6e5a7dfb3bf28046"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1aec3cee221e1cfc99a89f5f68eb1fa10213b83e39c6321e90ad228391cd9856"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c9473d7c0bc6470385331683e99be1b666026c02b3036cbddd0648837907c705"
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
