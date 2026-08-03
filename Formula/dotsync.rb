class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4b68c3b8e068de17e65b51ee4bf0ebd5a4317aa2b120db7f63b4e5633453e3f8"
    sha256 cellar: :any_skip_relocation, tahoe: "859701ffb12f8e1cbd770d9aef66cdc99985a214bfe9f610ce8b80408c7ef5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f0c35e1a16588ed576b99a57ad51a15161b49d26d2c74f639dd01716226acd84"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "8909d82756e1c8ce7c3a89b7109e1b80fb52059b2b81f542753178294f468cc4"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "f4f4047c0a8f7bea13337c03fbb75ae1fd72dfe98452d21ef9be57033cc8b61e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bebcbe824de7b9fb58c9ace5affd85c51e72c386be318a0ec2e1ace5ccf51bc6"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "721351f85a2828c15a1373840cc741260423bac47c0d597aa6f64fe5bc1e9171"
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
