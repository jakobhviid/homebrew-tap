class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ba3d1e8d5776681f19f8f4a03d0a1a0f4992a759bf1b36243005a8c02ea76cf"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.1.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "d566f9b609cf5a56f21e2e60b30a330bf568eb0647cae0f7432568dd5e9b11be"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.1.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "bc07a76bbfa4b2d66a67725c3a908793b478f5ca503402e7f616af458ee89aef"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.1.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "da9ba0f30b0eda56aa8934aae1236f84df285c389940f60900114403883ebcc2"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.1.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b0942bdcc44e7abf28145d5c5179332c3ba17c0223d50262ff01220d180e04c3"
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
