class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "2.1.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v2.1.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a3428ca05d528a68906b5eec64566b5af16bfeb55e4dbeadaf33979fe01146a8"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "76e4c7cf8f5200a8c23232d52d0947263e30d134f895f320a5c8dd119d41a074"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "1fc98d163e4e806805333e6a965a345d79430753cc1e2fe8d4ac6cbcfaa2722c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dd325f5e947c81fa7cfffa95638836587dd85fba478b3cf8ec18ad22b4900ec2"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3665e25bb3b9203ea23ad1a2b61070219f336922a660da2b1a66afcf838e2fd2"
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
