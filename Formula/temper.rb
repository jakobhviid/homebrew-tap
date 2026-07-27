class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5c93748358f563c33fac78dc61b00c4bd1b6809148ecb8745042293297fc2bf4"
    sha256 cellar: :any_skip_relocation, tahoe: "5bb96ae750d9ec63123e430b7cb259d833a1ce7000679a6d9223c7455bb7ee08"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "36eade8e66e89665f237be95446af7a7897b4d848582bf2b13766149bcb10419"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "09307c5f7dcb9bbbcd63a8e47c5f070b71c05669be8ad57ac1d57cf384b4c6ca"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "68d97e705c4524e2b98aafcf72d520b91e8521686970a09f0683852b4b0ff76b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2ccbab73d407b065c58e49ea14678f25a003949806372cec64a44d68eb51e16b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4be81c7202c3a506592d80d787d7bca037cf136e5796cf2d977c68f6043e52d6"
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
