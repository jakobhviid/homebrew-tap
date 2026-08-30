class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.19.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c4ef915c05823b2437abd8eeb879f34681063a19f53b06cb455cbfcd4ccfb748"
    sha256 cellar: :any_skip_relocation, tahoe: "89ec835e50e92d0984d2158509ffa954ed7aa4c330997a1cf7ca61aa4e4338ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08a8d11a035565c0624bcda446416bf43cbe1d767ff552c078079823f3e3b4ee"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.4/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "93c086ad0eb677916e8210a314359e8e018ca62daa70263798bc637b7a78a256"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.4/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "cb24c25348bc4f4df1ade1aa9be827e63e85a808043a24e6c69f32f41cc8124f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.4/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8889a4698224089004c2707fb51c574422995de7f1b9ea3da79ecadbba5d8625"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.4/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0b6835ea3803cabcab8f0dc82b71c9907d532a38d1f07e1a5b52d59b57b52843"
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
