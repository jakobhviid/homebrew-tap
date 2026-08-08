class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.3.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "246f2a3bac070a5bea14a1613f138f0a15f7ac6d3ab54ac8b45721d0852c552d"
    sha256 cellar: :any_skip_relocation, tahoe: "af99cfd2d30bc9df9fd2cecd204eeb96eca8578098d8825aee467d138865b6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f90e4e2fe3c499b72eb3bd2b06460282f23b3a6e31d5f941069b5edde9b42166"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.3.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "b0bc411b4a7a276213479041d5aeb6c2667ac21158c1d92204397199b0a70f34"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.3.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6f61da6899639e71ed70e14d5698033cb969e9fa764583d30e0bae2f7c80ed80"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.3.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "22a5c887efeeed9e801d2f057c217d85b6747eadf3d82bee4d82d89866c04977"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.3.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "931e5365ac6fd77102c74c13349499b4c339885d99a7f79f8525238aee13ea83"
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
