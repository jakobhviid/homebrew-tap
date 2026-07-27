class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "36664b7b6a89485a12db22eda75702f3555f3f0fa6165da0281505e5fe41726f"
    sha256 cellar: :any_skip_relocation, tahoe: "425a002f31d4768a7b447c28811e67f892466e9f09681f76d892a1524ef67296"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20b5c0f34de2424e4b81f62d4b594b64945b3c1e17fd1b307eb08d77205e0662"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "59db6477a963b357c7d4e0f23df7b03c76e9d65b5600231800f0c97de807f662"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "655be7cafadfe46a3b2afb76140b4a4c7d8ca3377791057ba30f8d454e329285"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7a62555df41c3e4c0a03c3f18c8f5582bd605573750519baea7445eeef742b3e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9998189249daa3d6e63d2afdd5e5e5a9451936e2dace129d2ee09600efd2fa8e"
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
