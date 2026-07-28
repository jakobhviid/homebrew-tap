class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.24.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.24.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2e00497c9b748ba2ef95dbd560795e13719a86ffffeb9b89d3ed67f95bb20f9c"
    sha256 cellar: :any_skip_relocation, tahoe: "d4df3bafd6df328d224f7b0fa3280b01497a1d7d18b6c529ebcceb63e6e2bb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "73b2684959a9c773a5a89a4c73093207d4a2aa90fa151a7c0848625738905699"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1954ba28e615af5c70a664b2f53d9ad191054452ebda26fcdbb26732a164fbd7"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c87e1bf78041952e1579736bc730a4c71b8017316551914768373e5d9ae78745"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6de13aa926c1d67c013069ce8af4d5de44fcf2b9dbe372d778ee6a732bb7cf74"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cd162b2f8b55df9555c968156f0b6e3ed46cc7eb0202f4ea1ada00d32c1158a5"
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
