class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.27.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.27.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "de8038d6d3d4a391b2c56f1f3b9c652e7f741666733cbbbbd7cc3f2f9cba8068"
    sha256 cellar: :any_skip_relocation, tahoe: "e3cff3a25e563f928a0bf10f6e81293de99df877bf2ef96414c3e932c6d130d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "babf1ef7d1c59b82ddb5438839d039f95e4f25cec0b433070e9bf3fcb8a9ef18"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "84382496d7c0729552a7ea4e80e68ff0bc1935d1d8f1a4b6fee5d6131ed1136c"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c9a9b2b792eabd953b2768135a64304fd3e1b5ed63a4304a21432b230af16375"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "509bd6e0c37eae293c399edf0299af1e53a87faac5a159dbdbede2b295c49e6e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "74d7be18118e99790a869378a9cb5de97203e435c5429556c3978992d90dc047"
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
