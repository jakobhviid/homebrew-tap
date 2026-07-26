class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.5"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6bceba2819553b1e0005fa9f295b5bc7eaeeca00b5fe5d06040f173cf683fdd5"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.5/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "fb9475b1d8c227000250bdaf4ea27567a0301e0a8548efd2868354aa7ef99cf8"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.5/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "8cda2e93858e387fa42d81ca2ae7268a22716771872d7cf00871219b9df2f744"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.5/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "38a27119635880443ec8d63a4625669117fe88a8e451a4d631c1784d6acfe941"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.5/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e3d617f2be67f080001f135297cc6aea87d897f6163f492aebaa96ac9b80b23a"
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
