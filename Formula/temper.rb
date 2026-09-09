class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.4.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.4.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8e44351b37a97dcd811c6271e03c105aae1dbe5e5237551d6f50de2dcb9e1495"
    sha256 cellar: :any_skip_relocation, tahoe: "a9d1a07cafabf202137a4bff4bdfba07a5d9346d798dc7b02e80b16984688eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0b09dc506ed757eb187ed255f6c6f16136e2f9257d55f81196fe9849ddfa5a9f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "080b6804ef6f8db147b9e530aa91c59e5925074432a2323ac433ad73b71df320"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "aac1514e1a8b118f27e0a23780a1f176703a9bc7692f42e1f222969af6fdbd81"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0d25853b1d022536f44d5c0f18e6503f4655a783619d2dbe060c4dbdcfa85c7a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7d95892004863a5eec295a9982dfd1d91479d59eb83441901475e9fbfb2ad09d"
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
