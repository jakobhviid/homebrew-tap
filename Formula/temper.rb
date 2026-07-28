class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7d611890d6a57a1830644b0129046ffb90b1ef703f82275f8084ea9722d89856"
    sha256 cellar: :any_skip_relocation, tahoe: "aeeddb1213594794d53e458c773f4579eb00b6e08e64c0e8ed9bc1664636e34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "29b4d8603bbf16854108bd7dcda251770dc3ea07d20e76bab8d0561979d8df25"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "d288df767c23314257bec28eff8bcbf398e7c37cfaf62b21292e9f9f2f70dc25"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "2beece9840f132b45b53633516e2906b8c99b67c7462c6fcdfe0e28c2d00b03f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6b44e201bd19fabf15d827890c1c0e4cdfa63a5cd10005ff91857294510daf32"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "71dd9f19ca4fa85084137d8a976ecbe8506a814ad64e27c65e144689f0256238"
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
