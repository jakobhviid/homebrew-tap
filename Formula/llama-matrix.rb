class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "bd1b56dcbc9f1399a566ca9ae0fe0edaba5e56eb0fbe98e18b073065e332cfe3"
    sha256 cellar: :any_skip_relocation, tahoe: "85ef3201f2837ccd990a43cc8b1a27c9b798cf470eb121bd520b509e6f5df41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c8468794ee172640933a29c2e57c43aec44037ad1a16b7f591ddd4cc160e0420"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "6db6dc1c09f4d33f22a476bffe1e2b4dcfa02b34c8e47365c2bb31b7acc3b5b3"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "5fae98febbd7d8416fdd8b211e3589031730302d51a9f9ea0285d6ce1e9fd276"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "22989bd8a024cf38b259214a4dacd68a1c19e87df40981354dc64981b06ce93d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ad650b16bb13d7777502be1c5c9c41712cae3151d97dd0b97771a47a7c0ce953"
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
