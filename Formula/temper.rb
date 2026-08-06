class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.8.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.8.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cf5b95680c25fab7b199a87ef59e19e709756f01db8bf44cbd77f9471717bd75"
    sha256 cellar: :any_skip_relocation, tahoe: "44bf5a28067454042907d48842649956f42b56cff81916ad7471d6f48ceb6fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e8bfe7878de249dd2123a483ec8d5b2c4055ac2aaa0c617e1244c98ca57d4f2"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "31ef93437dd55b2bcdb2c44891df46dc362c24fa08b79147934ec1f6ab0ef01f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "e2d769db09fe4a371b8f13194db06c1ec763f45d7b9b587dfbdd34cecc3f7b76"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e037278cf78dc275ec5ddecff37b559a02360546309e78fc1703889a730ad4a5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "77d13295169cccafea81fcfa7d11bd09e4cf258b45e135b0b5fa8818c0b4d74b"
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
