class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.20.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.20.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0246ee7ff7c3691a2501bea4e86a26018151b3a21c1f07b6c9905824ffd43f16"
    sha256 cellar: :any_skip_relocation, tahoe: "1089f54703f584849c6004324b082b404ea18d15bd67112b58054cbbe3bb1bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c829b1fa7654b0bee4d9e3b17e8009f4e960bd9a06f707c2c7dc172087528da0"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "2ea63fa8aeea5c615f21fd5d95c15a00da0a5b24ffd67a37a0e72b52dbae8ea6"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "da48e9180fc8bdc4795c3b15c78b79d3d8a3c7ab5268fa631360c1e5aa1e2dd5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5b588e78a309ce2fba60522ae1d2cebab4fac5b2047e633d29cdc5a7b9798e23"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "df86ed7ce704be64b6b5f30a49f59fbe083001bfb87e6539eaa290d565175bb8"
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
