class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.0.22"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.0.22"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "80cdee8af979668b6d3f827623c8101a6bbcd3eb38d8a8be71e6b2b4bbe46991"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.22/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "c19082ef963941a6e100f16dca1c6b3fcda54b60e1077e3122bb2447d4d07925"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.22/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "24512f570eae7955a044b272148b91db5053930b06d5025ec691b6b907587c1a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.22/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "72399ced121e2f352dd8e962238b12ec32122536ec7e9367116a825dea838b3c"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.22/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "35927135146c513776d0444cb68aa2c1927c61507739b49b5227c087df882d5f"
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
