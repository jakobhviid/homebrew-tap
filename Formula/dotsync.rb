class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.6.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "af411dc35b225c3c1cf571e1b6b5554700c3387fa92371a5b84848cf068be130"
    sha256 cellar: :any_skip_relocation, tahoe: "6c745e81cb8903425c39c29a4eed2587bba991e1258dfe58c6dbb8b2002b51b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e41873fd22a06fc7749de7765cba21b183d8ba5127bdc49ca4bf063f8053ee9"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "e130bfa1f8717838aac641547ecac6cb415e1144ec41197d77572c5a47b8e516"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "8172acc40ba44fddc5b3e19ab181dfb738b883d570ee0eae6801fce91df03749"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "11f1ba49b52e2ee89d2643d9e1e106b7236a41d312911469a9800e89377c79a6"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.6.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d99b2fc156af35a995f7c01e17e718e50c4782511e8fbd1955261b82353271e7"
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
