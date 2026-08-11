class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cf643568fe5055d8570479d6234ae52b5af6b3cb222bdc7310ee8b3f09c6f1ed"
    sha256 cellar: :any_skip_relocation, tahoe: "0cba5e7d5884dd1c7555f21a4873119766c325f00739120e6448bef4d45720fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "88f395738fa6fda014d3eb01e4e9dbe15afdd6631c47174b84c19c90c4dade10"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c18cda2c9de371fe75bfb5e726e95e6c4e90095ff3c51490a6e4dca01de2af6a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "730e40ad823eb5274411cc66f4a587ff5c6987699dd59b63b834dd859a36c5bc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3aca6f2703102a3828633d024ec88cdbe9365ccbe41375d0b5758bafbe9348fa"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e54dbe46df6347013794300b536dbbcfd9095c5038db2822ddacc39eead23a03"
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
