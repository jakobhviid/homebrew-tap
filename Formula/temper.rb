class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.29.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.29.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "40ca598c52e6be03f171bacd80000b58fb015d949557581c9ff159602a21c3b9"
    sha256 cellar: :any_skip_relocation, tahoe: "71ebe3590b21e1ab33557ca302d112fa02c5a81ad598a41b9b79130458efeef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "77de7ceb82783f9bdc094908cc89d3e78bfb40b21e79a1106b670c0d66fbfe12"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "8a69cc7545135e91862dad3d7b57036b9b8d84bc112af48c0683b998e1866000"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "2cc6325491b69396e8e6ce6eb5a4c6fab69016d3e2b69cfcd05571cf60cc987c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3450a93f65fc887f96404e1880acfae9cf92bedd78028e82c08587823cf2c4f4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f4d41dd25fc136a2d11f56d91e3772eb09fde9b3930aa783ef0af26bfcceaef6"
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
