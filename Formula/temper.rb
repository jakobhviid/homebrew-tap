class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.21.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.21.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7f29a19d093b7348408b61741020b00860ab2226716d3c80a0faa216002a2bd7"
    sha256 cellar: :any_skip_relocation, tahoe: "6a169bbce423e7b80a71824734cc2708f6c475487f574b9019e0663f675ad816"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f91a4fa04d9c965fb0d3f8121d17b4d15ad23329e8035f6b19155a4f04b2298"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c38541d8e25214f9d31a0c06b0260c0eb427db487f7f9efeaa511da27c5e1f02"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ed9de6c918b697ab42c658637178d86152a6dc7afeecc5900b3e7016e17daa2d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3ea36ddf66761063262d93438fdfba0b8a09c384e42e77a3d2e2ac754d45155b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "667b081f7bcd157f915ab892016e7ebba4a58e0d24d6ff4f2a15d4d73e542bfd"
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
