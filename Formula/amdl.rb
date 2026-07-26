class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.6"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7e7a8591a4ffe79f33f508c303e57d60cd4e49c303d7758dbec9c34d8f2da9ba"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.6/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "339849cd927b737ebea9e1a14d0e7fbd56146a8391a38dc25912b7d799ffbfe2"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.6/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "0584c96e6d4d3a9d58f2541d7a2800bc2d5c4dea30bb9150c559e24d1732228a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.6/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fc22d47a61932cbc0804a5d3c48281b8f0dbb9a3e30d5a191b51db98145e9aec"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.6/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d89db3bb8aa6a145b7ed24f0ba04c3286ad441ecbc5de990d64a4dab5c0ec67e"
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
