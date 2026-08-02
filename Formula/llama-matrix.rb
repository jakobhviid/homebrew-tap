class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "0.8.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "afdfe742e005b50267ea5bf6994d6d072f37d74570856195484550fae3077142"
    sha256 cellar: :any_skip_relocation, tahoe: "23982427ffd248a3946b99e9cb52458ff23a192dd196472c40641251aaf3e2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f97058014d43112f6422a3c73525b5668c56c78cfc2997fa26ab4864bfac99c6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.3/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "d9db98bcf0291382eb7a28be15874090804c7fbffbabd83d71745fcf1cdd45e2"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.3/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "c2ec8174db48fc75b017b1aeff8745f321977d9a495b6feffa0c7b026ec41258"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.3/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ad3f2d3f88c36804412301985b50c8ca7fa33b0db2c7216ccd9b14ca165ad040"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.3/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "214c43c0de40082c677a04dbb893e421205dbf5c3798f25eaa6bdc0b179cd405"
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
