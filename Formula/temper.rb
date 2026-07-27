class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.11.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "40ec1637af26ce8300520136f46e5d52d059ec73cc823dd4ee9d845e2d62a1f0"
    sha256 cellar: :any_skip_relocation, tahoe: "2ce1c396af796eaffb204d87bf2fd22494466c408dbb804f77e77ade391b9978"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ccdf84a06afacaadbc694cab23bb0f5d52860332fac6e07c7621d4b34f532c51"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "df6aa2e17e568fb49ea4e4a395374d50e6c9b4e13bb84d7dbfb0e77cfe8399b3"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1fded76a9bcd58152f461207b974c4b1ac79578aa0b68383348ed4658ece1178"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "014f0fedc3e17e16ca6d005c4c459b6890cd6e691d0824de9015e3521f7f1f1a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8c212385abca51ad2a693ca7269391367e2a2c6de65dbc402416d558d913af56"
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
