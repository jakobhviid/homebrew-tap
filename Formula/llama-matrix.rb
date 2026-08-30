class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.8.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b55e12d7b27339feda3148e9f0adae50d7f4af0ee0f5a9fb9ca41412fb1efd7a"
    sha256 cellar: :any_skip_relocation, tahoe: "a28dd1b4c23622a5ec53c85f2c2e2c0cb035058f25c3c78a8098b2fd99b772cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4c7982aae3c0456bbd19884ac7800fdc7086aad9ba6604c0daa4e3068dc6bf03"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.8.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "b395acf3128a82fae84212da8e48d0971cacbcf2bc3a5147a2eef2fc8da1c96c"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.8.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "325e19daa298c2b2367a5cb96d02b43bcfe8f28ad98dcb3e1b648de591c2cc22"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.8.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7524c4fc5dcd58583759ec704f0d8d30e511e7f413f2227e58fd557c717cf047"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.8.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "df93a4309024703083773d4c592d4e673df3d2b0de35a4e85a29c67ae5dffd03"
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
