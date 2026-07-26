class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.11.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ee78a586d21c786139107504657523fe16b020d55edbe62f2f9a5da76048be5a"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "2c2c75ebdfc1a137b79189ff88fac519137b580c3f65cbf3ef1502eae0629ebd"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "ed5b383b6ee26b8c3d66889dcf2670a4ea0ec27f370c45028b8347323378202e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d26c44dee0c02bf8125cdbea0bccf4c6311ae2d3fd42aa859e39551135f03c05"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "49267f37b1b05cabd5ad6ce698781f54231f46acbc41db877f6e1b2c0ffdd027"
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
