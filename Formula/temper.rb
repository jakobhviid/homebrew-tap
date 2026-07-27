class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.7.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.7.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "45181e34fc8bfb17f8400a6ef80ef5d4208794e065cec7f9830fb97db4f9ebfa"
    sha256 cellar: :any_skip_relocation, tahoe: "0b770f868d481d8f54fc6348bef2e13d0c9ccb67a61cb6bf00323db515975b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99132ef459dcf8b780b8ee91605c64726fe11a3154668a8767a0e3d5b686a99f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "89397a1c1a4215a7b68a60c88818df7b298440d2c4de1990c693df81a308a0cb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8d54837c8bef9c6ef1b65cc07b77dd1e3f320b4cb3d904c00eda415c1a141f22"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e669069838c5f63efebfdb218984fb6677b9a50e9ef699b19aec8644237fbde0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a3e974bee7e854bab5b186aa5666df260e8574995b16191cc316718b1ee0a191"
    end
  end

  def install
    bin.install "temper"
    generate_completions_from_executable(bin/"temper", "completions")
    (man1/"temper.1").write Utils.safe_popen_read(bin/"temper", "man")
  end

  test do
    assert_match "temper", shell_output("#{bin}/temper --help")
  end
end
