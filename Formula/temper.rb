class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.0.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4f9c282f0863dbef9ce0319a019ce877385e0cf3cd83844b9bbe75e51d865987"
    sha256 cellar: :any_skip_relocation, tahoe: "697fe07cbddcaff3f34fd5e66bd066f63b530310c3d981be124d8ab5bfbb300e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e6c519c9b54dc9575312c3b07a114c12fdc1b71b905c33070a0aa27301fb5c1b"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "17b16365a7948c5402a65db7c769201a3f430e4ad1edf3b040578e2ebc247e9d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "62286a0bd77df81b7db94ae34cb4dcba348754a80d9f66af1ff87b8d2732b4c7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a59de2f64d71d3bfb8120acd5ea611b3e97efbea140c720da6e0e1fec4231b56"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.0.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d318e098aa69a35da12b9237a4bb266c552aceacdf1cfd2bede09786869bb1b0"
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
