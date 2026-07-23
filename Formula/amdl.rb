class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.3"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.3/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ea9d8b2609ee5bc07ae2d1e95adbf5568c9e42f2d4fb1490c5e9494b1f7789c4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.3/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f9f15a93be7c949a399eff85861c759863c8aef89c781c152654af130deadbd4"
    end
  end

  def install
    bin.install "amdl"
    generate_completions_from_executable(bin/"amdl", "completions")
    (man1/"amdl.1").write Utils.safe_popen_read(bin/"amdl", "man")
  end

  def caveats
    "amdl is Linux-only. Acquisition is handled by gamdl — configure it per its own terms."
  end

  test do
    assert_match "amdl", shell_output("#{bin}/amdl --help")
  end
end
