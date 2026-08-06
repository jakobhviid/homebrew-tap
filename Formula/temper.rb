class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.7.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "93c939959a16c536e3db0d6985bf3054717507bfaab3af36633726617fd2ddd0"
    sha256 cellar: :any_skip_relocation, tahoe: "cede1b66cb46cc55a4d5897fe43151e5507d68adc35685cc7915cfe6f58ea15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "731ee91e8c0466f8081d7e9da708c2ac63c453dfef4bff260f7820555dc7e28a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "a891bfc8198e0d6ff2e7910c9bf21a21d4f5b12e9224579c69f14718a46140d4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "14e170a72f973dd559146e5f888d9ff762e7cf5d266da92cbc3e726af5e5d4de"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d48293bbf1eb86c102976159ed82b34a5e2baa240d2f3e927ece4209bd65c7d5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8524503d7f311084544e1c60243a2b26bdae9d63a391791772e17e1d263264b0"
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
