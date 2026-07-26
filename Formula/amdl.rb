class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c85840705497e18825cfcd2e82e42ca1dd8371d4dde2deb5c939c3b7e703b40e"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "659c2e4e2b0eb4b47a30c83ade274a3d070bc705d6e5f6355396f681d2f9f4e0"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "04132b6b4c27ee1a55f0ea252db6e26486c127f7b5fdea17efabf8fa3bca8150"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "14f081774cd20e556793b480c3d360f374fd09defe73007988338473ae2973a4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cd4f05f650323af53079b2c1c4dbd8482bd2e04a5165f62e3fe2b0fc3804253f"
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
