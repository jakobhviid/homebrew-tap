class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.3.32"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.3.32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "948d7e8b4754db65162042f1ad92784bfda71134d5c7a1a54ce66863f0512a02"
    sha256 cellar: :any_skip_relocation, tahoe: "38305a48031360e307e54bb0786af1238e1ed66a47bd6e6a570bb4b7be936f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6fe95b46f69c0a4fc6b8dba41a44aee4961b0dfec9c5f7ee4252268a00c9357d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.32/temper-x86_64-apple-darwin.tar.gz"
      sha256 "361ea68ff15596ebf466fa1e95ef921df7d3dca36946a2d7c0ecd0cf977bee39"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.32/temper-aarch64-apple-darwin.tar.gz"
      sha256 "b862d6e9b4f387b96517ccf4b8c6e226606da339765509bd580b30c4fa5e1b2f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.32/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "14044d35478d9f0057061575c3f3418cf0048978ad8d9b1e7ed301c4ef7a8f68"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.32/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b4d46b3f708a05f9912b3ea6fb419ccee762376d12d4db3eca553bdac2490360"
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
