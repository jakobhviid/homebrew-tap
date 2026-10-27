class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.8.10"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.8.10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "16eafe183d9d0daaf84693be29058aeb26a9db855e5bcf6a487247ff0ebaab37"
    sha256 cellar: :any_skip_relocation, tahoe: "802804f6c7311d2fcd32ff67263696aef0dfc84fd623917a8f50278357ad5d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "426ffced3752d6c74df5376cd28096989d0e68170de49277bfe5f451e4955047"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.10/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3aca39581a53669d540f038d78eff38726e88282d2874527ee4c152b0d871891"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.10/temper-aarch64-apple-darwin.tar.gz"
      sha256 "18df60b99fabe4b22896ead8a1429912c7b93fbf2835e4627465b4c1f0b90f47"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.10/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6f9c1d6b71c49a97429c6718c77aaf644066922e9e779119e1ab141e3d349596"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.10/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a523edb46a06f884d45cb049e6d3b7c8086af551feae6e7761fab4c7a54d048b"
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
