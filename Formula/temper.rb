class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.6.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d854a492b4fdbf7d11a0037261d9eab52a82c5e1daec1d2ba1a925353c815230"
    sha256 cellar: :any_skip_relocation, tahoe: "093bacaa867b87ee2a83e1d34f80207e36681ae863fa4183418709d9504079fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca084440afde55d9fdb0496b126a9440b06e0fa63503bffe611dd9e2e71c7ac6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.6.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "22949f7ef4ad2e0c9d54393bd6a0d0ad982dd0d6e00ccb33f3b488007f38cafe"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.6.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9e2b3ae12bf5a18efe1a86f72a40055ba2d34efc475c70d9620b1653f4d47d88"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.6.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "db953b22ff57729f745f61d44055a9b477fd21418d51f9e3087136d473b66c46"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.6.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dc98a1ffc8e6fb8c9de13b647c32d2648817348c9b345c85b3d770690b787c77"
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
