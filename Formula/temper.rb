class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3c880f627244dc7573d999962565b56a51010f6773b64a7d9387157f391c8140"
    sha256 cellar: :any_skip_relocation, tahoe: "c2e402fd7e9efe50fea5b7de5caa96076526957d82fa9621053b9ab0777dd0a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a9f4215d4c246405a4476c59b51cf24e0b5383cea291d038daa0cf7731cbd4c4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1b3fd3aeabcca7a71f77757d824a5cb93bc0641e959c93f04418b14fb97a1270"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "cb526d7d2101dfd2fe119295dbb279105368c46ce5684812f324fba6ddfc7f3a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f80d7ee817825cb8b1d17b7ae798aebf6b8f06014142a3da2534037d7a6eb537"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ac2335df356e9172bfb2631501e9489bd9d7db123e7a60ee0145e83eadce410a"
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
