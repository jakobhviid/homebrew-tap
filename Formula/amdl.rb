class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.9"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7f6714a8040db47463b08563ff1b28775846173d490b35609b11f2a585720e5e"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.9/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "c89594b29f7e67f89e6e54a55588551227602158edb36e8c20b63d9faaec07b4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.9/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "c76c3213e3bf9ee68f02a8c267c076792b6f27917b2e82b4376762bd1d31e2d0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.9/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "468ddc2e179e1c8ad64dc008e9a8b8ee1efc347e48e9ed122a30fb1b39702bd9"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.9/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d249d5be9ccbe3c23a797c09015840f8fa5569b69a83d8ddfbca4fd7310be926"
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
