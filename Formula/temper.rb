class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.7.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.7.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f0f5afac3a94cd71ee3d917e762b8609a45e98c06f86e87def57b77828857be2"
    sha256 cellar: :any_skip_relocation, tahoe: "0617318383bc6016b648e2b8dff88f1e897e7f1a3366a8d6a412f017dc4f49ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a49921936de519ddd409757515612f946e910beb139928221ea527df6cfa4a1"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "30204876bf6c046421a1f084a48508f7523d460606b58a2b99a1b8753a885c89"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "b94a2c84396a15e49730bed7bd929141523f1ff19b1573dd0dd5371c9360155c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1c14f1ca95af0c9497964399234cecd65a3b539079d738b7ca5b68229ea89137"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.7.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4a69eaed7e3ec8634f7fce24a324dc7f58cd5a115e0d2f993a61a920614e9537"
    end
  end

  def install
    bin.install "temper"
    generate_completions_from_executable(bin/"temper", "completions")
    (man1/"temper.1").write Utils.safe_popen_read(bin/"temper", "man")
  end

  test do
    assert_match "temper", shell_output("#{bin}/temper --help")
  end
end
