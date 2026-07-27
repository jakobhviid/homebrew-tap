class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.10.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.10.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4f42675f9856c850af112e6b803ede8809e68b43962e4746ecb024de9067465b"
    sha256 cellar: :any_skip_relocation, tahoe: "aaae9ad38002e4869ae81a9ef908a4512184ee2dd322e7ba197c03a7ec2a0db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e8247a6ff508d48d56186c9ae2338ffb9b132237b30860fb42e4602c8b08f226"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "eab31c4b6f3408804672eea6c603d5a3063fdac3cef6fccc2c7b357b245b99a6"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "35be40af376b756ace41e5b42b0a34c5ba93f9ba4941e691aaeae700c868032e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f4d853f5087af51815072729a345f4df96243024350691d48817e0c5b9fed2a4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "239651b2579e0bdb76378dec5101841a4a2e9d5d53623c3bf0fca9308441e183"
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
