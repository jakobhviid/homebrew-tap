class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "51cb8cbd7f8c6d902364d941ab337430ee9e347d418a060f565e3c60453f7733"
    sha256 cellar: :any_skip_relocation, tahoe: "1de5fc4c01b25b30d53d85ac47b7aa33e388921cc0998b888c9ced65439b3400"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "126633352bb4bc28b9e8f0e6df6712fb113221855bf04ad6bf15247429de2d04"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.7/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "e3b7fa41910f8520b61f423c3f873211d0e30ec240e9af41264f62cd3813caf2"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.7/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "551d73947b573f8f33c4754cd17af85bbaedf6ede7daeb98b4e4e272b1ec4a56"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.7/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "23f40d16822c92bbbeb5e4c3dd2211020c2ccbe61cdbc48abe45b1cd26ec9836"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.7/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "66ba45c76c5c43e6afc2d7687641655d70f0d11bd553a0c74637fa56570838d6"
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
