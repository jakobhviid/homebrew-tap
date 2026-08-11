class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.10"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9c6973aca6de91b2650e42ff4a74000bad79c20cb0a73027b85d9fb4f4304ef7"
    sha256 cellar: :any_skip_relocation, tahoe: "9f6488ce5f149e4b8c2c37258ee92344e3280ceec26e2dda636bc8a6f9ee3092"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4bd74800553d39fa309e90cac88947751f0758ac3dbe1e4933a90c6a1e9c16eb"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.10/temper-x86_64-apple-darwin.tar.gz"
      sha256 "125a7b5f8b8fcf091593824667b15da966f11e1041a741d481f9adc8e01061d2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.10/temper-aarch64-apple-darwin.tar.gz"
      sha256 "24c5262dd5b8a54dd00755dfd7ec5aa13b59cd580339fabaab9197d74ddfce86"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.10/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d608eaee157fbc115dfe61cdacc3d394f6bd891fd3dbeeac9f29cf8909ec97ed"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.10/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "98f9ba0e9383ecf1f8a3683101723be4a3401432f8b6aa9ee0b39a43a7506bc9"
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
