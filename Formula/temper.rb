class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0849f83616a7fcd132f7b78f3b4a63290075a09340f6afe1b8caa7da34ffc474"
    sha256 cellar: :any_skip_relocation, tahoe: "b408f3dfb2ae842913e7fb3cc2acfa7018d479466c2a743551f22ee3ff1846aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f6ad714b2f9feb2097e99c2dcd9476925d440465ac32a7528b11e7d8903f6c59"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "bb4fd26e966691539dd0c31da1e340a8e293bdd2eac43f927ecdf2b2d59689d1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "cf244e914425f3cd78a5048696e92b8cf1fb26bcf18cfeaf078936e15d622115"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c06d258971cb535fb56c96ebb54fb9e936be463120297d913cfdffa455a50117"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8e0b834e04271b75e0ad12cf9a43c522b879220017c977db05155953a143afce"
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
