class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.4.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7d03b3f1c5d931c4f4cf1f96473edec21b68b2699fe0ee666df07e9c9868009d"
    sha256 cellar: :any_skip_relocation, tahoe: "c6d97179d59116f90be334c732143d1cb3bbef614b9be85bb2e448a8fb1729e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b1e08a0a382b7f7277b959baab194403af72e1b1c7df7da5236006a09031bb8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "5483a4f2b8c24c54eb53269581cd17abea5d73df08278a7e62314cea246058de"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "970fdd7e475b57def579d280d06ae00b3a661a62cb1d6cd12d52b949ec2a944d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6d544aaca8416d30075a9b261e3afe1e1f0165bf5b40c8168cd6fe38f9381aed"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a178f4225bfbbf455f8a2e6e71bac1e21e22960ee8590ad2e5f9769b43af6885"
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
