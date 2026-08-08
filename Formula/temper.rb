class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.0.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8214cfd7f2b1bceb7e9cd22bc2c7c4bdec227827ef50052b6cf4cc93a78e2fd5"
    sha256 cellar: :any_skip_relocation, tahoe: "28ce84889c9c622aa2b18cf4744e2c48c00421f9862b250b1e52af3cd9727d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5d8be6f7f03ba356f3bad2ea7c82ce999a1d04dac1394bd6e5853cc48883a267"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "f2786f2c6ae83e6c146c6b77deebd6899791d37eba2bfc6523a32e332592380b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "00580385add7cc2fcdca9d91276e916b9743e60eb55e0981dc6bc0bb3a156f25"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a274e6dfa0c913f8dca0de24b6f170a4036a1e8b01c6f0c118c96b53edc12b6b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9e071ac431107783909c70b0da05bf4ad3a28e5f5c13591057e1360229bef449"
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
