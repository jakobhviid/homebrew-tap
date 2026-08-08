class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.0.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7b674a27c795c10ebe050ce4b812643779d2de475beb1b04e661f9ef34cd3c54"
    sha256 cellar: :any_skip_relocation, tahoe: "32bc8eb4fe32407b934b0f400f9ec7d9a580edb30519f577cf27ee6fdd92b3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "153b990d76c6787e7d8a25c37a48a79e9205db9b1a02a703a659abad8de7ff89"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "a57301730b29b53f28a265ded19b4a731055ed63ac114e065363236931aa3c13"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "e8d5658586d6ef6b823a0147a00c09ceaf86556907711ec400695d7ea1f0adab"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5bb2250cce1dd4c0c69764b4cea18ec543a86c0b346fa141dde0776a79b5b0ef"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.0.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fa0f8b61bbc698c5b9cdee74daa9ed4d41a11db5346c70d243f7700a53d638eb"
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
