class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.7.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.7.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7fecdd84dd0d0a232a4e177f9d008099d19f79573fe1fd47cab7e8fd0625e9e1"
    sha256 cellar: :any_skip_relocation, tahoe: "5e92c0ec63ae633eccdf051e80c7dcfc74b015e522d06ce3a7ea95d964564bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f3cb9018ad2e6840e365f27cf0b9e4bc5cd8c543b014b19c4ca13eaeb25846ef"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "40171b0d1d92bfe9f306ad0b5b5797b13c623a7b5354cf71bcdf0d708f4c8f2d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "fd4ad6f5122e06491727c741bf2408719d40f7c16ee8f6352ea5c9aac7f31cf6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "49cd2eaa7211f85fcdbe84a7f398913fc6a1342346811bdcb844ca1a420a28d5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7d7b2a6381623cf2cb1e2b1ce8ea43d0cb335a525a9f6cf530df7fcf5064ce0e"
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
