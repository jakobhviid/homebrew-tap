class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.4.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5ecaf16d8bea3f28e2a101ab1d8a3c77d0610620717735034f27e75cef9a35cb"
    sha256 cellar: :any_skip_relocation, tahoe: "c00c9cf92b883ba6972f51799e02b7e48eff1db8d3a0e93d5f74f33c7ffda614"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaa0333d6c4dc42227b7697c89bf11617d3cb5962bd22f6cf719ce99f9bdce38"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "8c49283b13e1fcec1c83f16927dd1a99814120e436a6f82b6781866d5d7b1395"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "0c425fb29935c637af465ced18dc6639deaf7d2f3bb09ad848dfb96ef83100fb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4329fefe89b4d27afd05bde7206280cebaa9c9e9b96cd0e62e391f5c13fe6108"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "10cdef60d1c83d2d155dc7ed2a004cafd695c7fc736958991d9faa40b3397ed0"
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
