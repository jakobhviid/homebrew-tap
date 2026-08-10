class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.6.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.6.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "004e38f700414c5aa50b9ff033872a1c9445993b3f77b2309eecdab54e6dacf7"
    sha256 cellar: :any_skip_relocation, tahoe: "a09fc210550a2a2fc9c04c8fd81e1b23debaa2afd701797e87134facb613121e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17ec0276fdbc1b000ec3855eb22c50b43414be95e9829b8d34799e130d6cf62c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.6.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "26b4fa98731f8cb15e0e03ba9488dff19e690d13ac25c0e5234aed8157da9874"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.6.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "43451b63ea4ac1d8d48249b8c79c5db557915569333f1628580c744364f7bb7d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.6.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3496ac561401d7d02ea549d5c6a80d6b6a1ef0cf607a670d1b92bcc4aa62e77b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.6.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d5c21dc5daead9da95003851e5da3c4d04ce45de55c5978b5513ee1c947ec17e"
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
