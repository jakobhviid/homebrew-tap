class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c0e79dfc0d5bcea005ab184479d6099045b9a57078893590c998dcb174c7104d"
    sha256 cellar: :any_skip_relocation, tahoe: "a7fe23cc999a3cce51b62a65e483df0d6b4ead83a2bd45fb80b1e8186505d6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7db970bd1c2dc38e77c0d8cda4e54aee9ac2aa1f2c6c9c5cbd8bba75b9f1027d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "7a297ef7c26a04f8e1ba382a865b6d375fe581e2cd1baf1599e256dea4472e8b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "97db658d07456aaefee4cce6e5ec3d83d4f44895a45ff64526943ee4bd5bbfe5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "439b54376422ca336dcfdaf1dbbb604b3edf5c9a6d2e64530b17d1adc740458a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bb4816d42c9b699e93d8326969543e857247c99097016c917eabf5154cd3b33e"
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
