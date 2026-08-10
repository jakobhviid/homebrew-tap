class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.5.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "736eead124d2232589d789400dfdfc3a3439416f2ba6e6ff7c5ce4ed83e60b89"
    sha256 cellar: :any_skip_relocation, tahoe: "e21f336b6fa98bafae5797fe48587ffda539ea968727f0e884e578e0146c133b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b56db654ff1151d8bea5acf6203b0cfe87e68106730734a1eb5a9d115dd3901a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.5.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "6d2bc185a632666dfb605aaf77340f74c25c04b531bfdc2b88a744a1a5a42f1f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.5.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "f9d77772feb7c5931ae40ac6405e691f96390623b6b3bcdfca1650334c6b8b73"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.5.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c68aa220b7daf536114fbd6d46403f84c8ddd5289ab0e596b560e1e515fd2224"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.5.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0fe20188dd120f65e1b6036e9bbe055c67f61c18ef5ce37454b76e569c55cab5"
    end
  end

  def install
    bin.install "llama-matrix"
    generate_completions_from_executable(bin/"llama-matrix", "completions")
    (man1/"llama-matrix.1").write Utils.safe_popen_read(bin/"llama-matrix", "--man")
  end

  test do
    assert_match "llama-matrix", shell_output("#{bin}/llama-matrix --help")
  end
end
