class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.41.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.41.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9ff305e071b70a61d1058b6d73d22bb17dbeeece5409676dc557fcea01be9410"
    sha256 cellar: :any_skip_relocation, tahoe: "e497b5e6354639984437ce4d770632611980b177ad76b54864631357f9a44651"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be7c61260b2786a4756b319dad15713208196ed94aebb1f1bd942f86ab4e7c3e"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.41.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "e515fbeb86977f6c0e040ac42a7d311460cb2cfbc8c8a56e87ffaa62c9e1e62f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.41.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "15dd3fea0170524e2212e0383d0cd3d4a139b40becaa69f761643842beee88ac"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.41.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "581dc0e4b6db11e7d4039cf9dda2c4b0436d40cf2774eabc789cba4ee6d23544"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.41.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7ee927f39851ab1575b57f1d145102d358663b3015482b95366a0bd9bfb9aa16"
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
