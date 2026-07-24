class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.12"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "62c3585f42b2ba35513f9aae9099fb10f97618cb835d217af8bcb43248a3cb48"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.12/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "6041329ec30baa0a7383cab8eb19c70a2a40c358070fb8e6a65b691b449be40b"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.12/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "6395d348e618c4c2d2a9749e0d1466e05c1322bfc7e8fd86a392e8ccd55f3220"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.12/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3383ab3633a9ee43e3154f754c98f1a16c3d318bbafd6145dad61d9fc8089522"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.12/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ca2c69fafd5e80e3386686718ff2d917160c82b20fd2d4693d6389013ec034b1"
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
