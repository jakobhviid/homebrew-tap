class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0876cf24afe4f59de1933988a87f9edf39191f541f7c0885d913f8fe978987b9"
    sha256 cellar: :any_skip_relocation, tahoe: "cf003fa242fe778f0adeda6464efd6ff966849aec44ca09bbcc064e160a53f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "058f58b3ad5c5bc41ec0c3950fba02530a3c1c1efbf4428542157ce852412b74"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.5/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "eee6fe23357978dfac45b2d4adb856685bb6561d33a19d1c2f31b53a2019db83"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.5/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "1c31ce61b40f7dccf1827d126ba597c1a6c590d992992e2cd8e02700346c4b46"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.5/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0170f252d1be4a032f689edc353e2f367b2d3c2f4d3c37419dc28caef6d40627"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.5/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "98964697f74d68ff31529334175cd4e97d5e7ea33119d5c78fe5cbe88530d205"
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
