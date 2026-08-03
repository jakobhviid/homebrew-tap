class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.2.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "601cbc22f999492f43c0c132450ed769f994106ae257ca2811cb1ba0dc5c6b96"
    sha256 cellar: :any_skip_relocation, tahoe: "6eb4715cf9a5e7f8273f24092ee8394a0be59337f7c36dee1699da7000c30fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "14e0ff0e1e298d0e4a946a0b9ce65f12a640ea7d19d1597b9b784f3c2473e8ca"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "9a7cf311d16fab3a826f3d20846df8a86786b5d9a3ab3695c7478a2d99da23cb"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "33ea2905ae18def8f09d4a4a04ab167cce9da3662ed34f662cbe0770911d7e1d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d49ee4351643dd9e3ccda007db851868395e771753c2724091189946a5598203"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7b700c451ef0bbdc4aa3128265351f71d801bd52ceabb35aadeee3479298bcc3"
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
