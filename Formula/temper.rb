class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "039a03351e7b0f1cc69eb0840136b268944a30583c436415677e5c1a00e48918"
    sha256 cellar: :any_skip_relocation, tahoe: "ee8e0e233bd5ae89c69b0293c6132b4017fabbe6c254fa7aeedda54366a2ad83"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "78b96665944cc6c06e510d1c4f8064663ce2bdcfb9bd041ea49647f9533d36bc"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "26428c2d0f9622d32a973caff0d9fe73cc026854a56f69e4fab630bc76e21167"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "be519f7c776db1bfe3a6b7fd92b72104781d9d00902dbc44c05d894617b4258e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7aac8900e9ce2c6c5e017c8080354e19a84cf41e7c3f9f90496bb29007609b77"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7f13498becd2d42e2161c2d3f737fdac0ecc56889d6d85ea3e293c096a02b9ae"
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
