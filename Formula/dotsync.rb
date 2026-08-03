class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "14563e08e6f2365b4e49d34b886263f8db22773862f3ac669ccdc907197bfe62"
    sha256 cellar: :any_skip_relocation, tahoe: "46cf06b2cea199652287809043c2e034848e014490b54c5bca84e0c2347ff2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "56ce92652e514974ea69e1b60f418f38a7500b257b5caeb38eb7e7b6a736878c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "27564c96851f55ffb42f5543fffcb9fa7f227379fe185b5e8a916bf0ba2cd893"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "328734a23f95c83cc6bd0328c85d2e88fbe5c410267cc0326cdc842d4eb54442"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0124d126d4c0755a3aa0d179561a1f93d219848ad23793539e2bd316055e69ce"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5aa84dd8d61ca8cb92093655c18e52548308c2de90f58c537c60619b188c0a5e"
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
