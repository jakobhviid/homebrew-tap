class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "479245d62b89390c85d3100344ca2b225bcbc5c5795a495011583b75f4d1fc98"
    sha256 cellar: :any_skip_relocation, tahoe: "7f54765ffa333200e093ab5d5fde13e5dc378efc58a81b17f9abf0365d64eb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e677827e231d9ab11b354ffe3493a3507e49cfbc1a9ffff8e5bb392b37e66704"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "25a41c347c3df7edb940a6c36a91d177324b274a7afc33fa002e8aced1924f53"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9fc46f476261001a09eb2ec2460a8e24dd3090968047fa3a45f4c0dfd473a1c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8db63e17a3fb4bf5e80184753686adffd78b2998919e6415a9d4a75f7852b93d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8b37f36d82e6213f9d3148164c220f4b7f3249786fb120f8a835ed82c2348874"
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
