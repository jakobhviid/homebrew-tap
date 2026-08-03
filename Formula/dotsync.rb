class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.1.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1f98114b8e44a1cbc3058493d92b3b89b2c8c39faa6bc63953efe4312985e135"
    sha256 cellar: :any_skip_relocation, tahoe: "7b2bc9ef56c316290e9f13bae1eefbd64d184f63be2d56b38236d2389af574f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "23e2f84b12b0873b6997880ece4513a4a586b996f0080081600585cf1fcbb146"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "c4b69251368441ab27bd200165d147904419afd784a8c73f734cce9b97f1e068"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "adc7345988e7a2e243e4f5d6e399f8a95044316a89e42b98db6d1ff03b3a2107"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7cd947225d90137301de1f3202c2450dc866ff505ef947dbc484ae5ae7d91d55"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef700e76aebfc32efb69828aa539c0ab7ded5d9b68c887e7c315d44cf57f9f54"
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
