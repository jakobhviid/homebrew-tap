class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.1.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.1.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "40074ef98af90fbc1373228c2546d6e183496ec253c6e36de0cc5e713a45a442"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.2/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "4c5a17d11200570869de3830bf41af2c08ba220a2343a6773bf3cc22181530e8"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.2/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "0fadc287fa830a33df2280171d441c1235376e9c7cd8125bff9c76d379cff750"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3fcf2842894ad72ed7eaee2549430a1088b036ec1a636a0b146eba63ff345d99"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f4999ea0ea6a2386889ea267390a443eb0bd61c42b76afe32f3bcc000e0baf1f"
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
