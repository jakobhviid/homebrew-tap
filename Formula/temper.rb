class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.9.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7eee3d997bbca5c2b26dbc248080395bb837689035edcdbebf568ffb29c5dda7"
    sha256 cellar: :any_skip_relocation, tahoe: "6156e139ea227f6f628745cf40f8db4e51acb1d91ba0d6e80907060f2d0ed2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0bec48aa36a6abc7f2bac194fdc6bf18afeb7424cdf6743a95f167df848c8fdb"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "ecd784d88c5e9194805a7c223b816e1759f7f6bdcf1f60df57c026c094bdf6c3"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ab6556584b45bbb2a7e3b95d07932308c5432ffdc81cb77d59dc319742975649"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dbbc836e7bd51f8a8b781748b716a09d4cc8c51517a78058757f501ea798274e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4e69d4d6fd28ce5cd23cd12bc6c4e57e6287a10beed7bf225f24c2286eb4d103"
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
