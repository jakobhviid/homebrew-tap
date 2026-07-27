class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.6.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3c26f84775f67b1a9e6b68504eb5f8f554d3516d7792fefbc6211bcfea8851af"
    sha256 cellar: :any_skip_relocation, tahoe: "4bc5d1fb5ce1b04d2e4a898e2082e74fa0feacdc6b669cf8ab2569815de5158e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60ad58cfffff009727bd89d246dcf6895a020606d04565a8cf89f355b2829791"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "7b9d5dec285d16cab7a2b6dfc4cd0fa4dfd0fbbcdd4f3d798400b32e0ab37c10"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "909a196da44484de33f344effda6dfbc531efdb70e4f95f9dd2ee67d3eae2acf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b9d8fef2008c33689ba561418b389cea594e2c71e257a32ad9335b753747393f"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "571c6d40bae892ac1a4412bf273bc9f7a374695f6ea2c2fe67461b73394e8fdd"
    end
  end

  def install
    bin.install "dotsync"
    generate_completions_from_executable(bin/"dotsync", "completions")
    (man1/"dotsync.1").write Utils.safe_popen_read(bin/"dotsync", "man")
  end

  test do
    assert_match "dotsync", shell_output("#{bin}/dotsync --help")
  end
end
