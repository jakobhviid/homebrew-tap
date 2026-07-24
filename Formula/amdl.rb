class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.11"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.11"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "727c218ad33c2f63cb3cc5a48d24b26ee6c8a52404400fedca92b159504a3e83"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.11/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "29832b7e3b0b5612c8e6210922f48f2c72bc54af669ff6c433c9861d79c727de"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.11/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "dd3d8b7c231fd851547835f26a40da88317f7502ad9b5ee1fb167bc680baab2d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.11/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "24940f6fb15f8648a4ccc72c9d8cddd9aae8a6688b3fa2e6d5906160ae11a844"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.11/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fa60b4ac202f51dd4ccd76f42d37dbee7ee59b31870d31c7d947e13d2943d06b"
    end
  end

  def install
    bin.install "amdl"
    generate_completions_from_executable(bin/"amdl", "completions")
    (man1/"amdl.1").write Utils.safe_popen_read(bin/"amdl", "man")
  end

  def caveats
    "Acquisition is handled by gamdl — install/configure it per its own terms. " \
      "amdl auto-detects Apple Music cookies from your browser (Safari/Chrome/Firefox/…); " \
      "on a headless host, pass them with `--cookies -`."
  end

  test do
    assert_match "amdl", shell_output("#{bin}/amdl --help")
  end
end
