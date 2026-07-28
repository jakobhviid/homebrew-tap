class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f547d090df17182d9aa6a6825758c1b5d37176be36f5162cf1a8b90ecdd70c61"
    sha256 cellar: :any_skip_relocation, tahoe: "69ee3c69b795ad4ca7090a5bbff1fc62bb7503d5ac1ebf365d91b6808b48acf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "017db07ee411b1e3685c7c075bc2baa11304a768fa20c3967970f3a8dfc85722"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "cd0978c9e42e11d535d50881c46609eb0fe692c7fb0c2c4a0e3ad5b64c06aa81"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "2c4337d03d33922bb56c51c4a34e4e8bcb5aa41245de320a426542c7b5f1b222"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "602e1a1cf3be7d84c22cfe2f00a7d026cbadd0d8028007bcfa84953325016455"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9148d24373cf4a77d005d22f8aafb244760f6cdbc01fd78852130fa8e1dd77d3"
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
