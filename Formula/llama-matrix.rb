class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "61bf84650098346153afda18d06306ccab3111928b213a935cd49b219a38594c"
    sha256 cellar: :any_skip_relocation, tahoe: "46a7abbb7de4f0712c2f02038cc14d48b7c5b4d825e888c66f61fd035aec9953"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "711a214815e819cf663119c0ae01996c4b9ad725588bad1c939c849dd906cd4d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "77d5b4e35caa2b4c10773e4d338e7eec51fed038a1162395126121c19a8308f6"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "414722f8cb5e818dfe9f3fbb52a653efaf8193ca50f0142f780a10fc57bd4d71"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2eec5ad61915a4fa16f04287a6c89c1b396f5d9b22a586e7c2625db621640bd0"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3d10f2bd4a230570b37b42bed54111d07e7547742494a0782f69306253e63f10"
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
