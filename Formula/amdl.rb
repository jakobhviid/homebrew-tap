class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.2.17"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.2.17"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2ae6c7d3fd7c92889f6a6a570117c4cd985a1b372fdff0b9786f13d1373ecd1f"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.17/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "73425e89a16482c98733013eba89cbf060c207ec9a8f2999984ba46834cd3181"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.17/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "e5107b9b70e7f92e07b0e867e50f76a4e89d6e143293931db0767027491ac04a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.17/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6b121876cf885d7d31f28a68b4fb30f1f3b18ce528c5e2a9370b3326209a90b3"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.17/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fe6c1f2dd29e3569790d057cf903ab8f4fc0d06043da922f00b510720947174d"
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
