class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.6.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "041687d201ee16890a3c0d65d21f428415b199984bf0ac36d75235d7359bb295"
    sha256 cellar: :any_skip_relocation, tahoe: "c1417f37a1ab9bb32bf9ea37ec5147826d5a6957b1ba8adec1b9933a7a888101"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "37c900feb09ff43cd26d32bcc5dd937163e143e1d444ed9400ec18b8adffeee1"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.6.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1f9bff9c28e4d4af3dd479b4a5266628de7d098bce7ea6b24df4febfe2377f3a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.6.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1c4d55fb9f79ae5673992ba53f58d4b68ff6fe93b486c4fe752c422b5e30ad90"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.6.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bb9005eb05c2b33dce3de84e9a9eb3f57e2857bf52a61805b1bdef17930d88f1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.6.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1e76f75b2c72bdd10ce91a7ae72972bdfacb568331027881695dd7b98c88107d"
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
