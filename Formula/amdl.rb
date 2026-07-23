class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.4"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.4/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6a69c29e52d4f42128fefa1fe9240bf1ced97ae8787dee8a74678e3cad3a205f"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.4/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d96ce882d621aee6500afe865b4419cc1ceff482995385d912ea8dd72120afe2"
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
