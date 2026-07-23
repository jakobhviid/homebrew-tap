class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.2"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1b13b0e3e62c8f69a520e3d7238a64424295efb5c888c36db347e65bc814cd43"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "810745235cee4270093c346fa3e19e321373a056f525414cbb6760734c363a50"
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
