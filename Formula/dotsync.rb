class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.4.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "37d89c1b26955bbe65cde3b8e18b261b5e8daeaf01a48ade40fabd54973b3ccb"
    sha256 cellar: :any_skip_relocation, tahoe: "cd104391e1527e9db43d3296a9db21352dcdb5d5e38d00e228f9e4b8f149eac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f9a448b32bc8eb3f40e0e7681ef272fe106cb87e447fb87d03a2a6ca25a2c8f5"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "edbfd208802c513ebc78e8c28be2650661cdb27493a1c11201370e8d369f59e3"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "713a83fb0f866f145af546aeeb60dc54b45ad96e7e53ced7f54b59ec0ba2ad56"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2213311b0438a13059dc59c1efadeb9074a39eeadeecffc487aa6f58fe84db38"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "047409ba87e9c96eb3d85db1babf32c2fae68471c622a8a1cddd03c2e8d9ab1c"
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
