class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.0.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "08cc2a918938255b1bab7dda6c60abb5f37c83e0b397292b9ea665473646ef96"
    sha256 cellar: :any_skip_relocation, tahoe: "0ec1b7a6c95bf0fc827af1462fb4fbf5154705811aa20882b5f401d796d1ae5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7d9b333c45b135359271b1e6c4a738c35f71a83ad1faffc55216983c8a13250a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "353c05d1290a88aec248c3a657d41bdceb3b9ed69238204f529a092512fd0261"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "74b71bd9e7c4add4b5a23ec56931158a6165b7f9d529492f17d7c97b4be474b4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7fe9f7a138e281224937714fc450585b727ad0a2bdbe8f3a88d09a5ce5d122bf"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "101b164ff3c81e3821fcf172243c80b602254a470116d1a71355835019e84457"
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
