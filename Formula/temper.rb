class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.11.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2b95fc5da09e2e24c2549a55e03cf643628a1487db2813243e246eafdf2d42c4"
    sha256 cellar: :any_skip_relocation, tahoe: "864fcf4abc4e7cde16029b0c1136c0480e06cebfa875732564194f571c92fd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2fce2d156d295356abfba05733f7d09d55df5a21dab7009b88ff9441dffe248f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "e11c513dec8865e14269a7b471893577c07b7453b0365538c4772ac3014804dd"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "db56d0fb93dda6c52d38fe03571634d87cf8c03c053664c62fe75121a00d8118"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bd451fd8e3571fe609e88a4c624d78b2d89eef0d78e60226741ba5e972903fbd"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "19fe52aab136a19ea87d8907f71ad40861f0a2afee9c53468bcb861e665ee46d"
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
