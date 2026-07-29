class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.36.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.36.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7b166ad4b8f0f00e7daf9b666a2ff4305720eb149803424b341872e91531ef78"
    sha256 cellar: :any_skip_relocation, tahoe: "37620e1ba938e67b73ab179fc2cbd1001a7bcbf8e5d4397b7e346ccd0105e06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fcc9a4cdb881545b2f48ff1f3a28484e367c2a84a54e54595887317e7c6abb61"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.36.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "534bf9166e756a8e8b2159135e3be3eae5a6cd8747adaaee6366f20084e1157e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.36.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "06b4afc937a96a6b0884a119b72cf926d7aedd28f556826382d9d0594a2cdcdc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.36.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3f7695e49020073eac99fe36e87be030e72a19b091ebf1db9f524e21989ddcc9"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.36.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3fa2eacc8543b6bc1c8e1cd4df1611c14139e656cfbf23d7f40f4fa7482bb2ae"
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
