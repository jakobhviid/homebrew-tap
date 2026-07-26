class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.9.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.9.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e1c9ed53eb6232fe0b40ee7acc59ff75239d0b4986380c22ea172a4a09089dec"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.9.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "54809e87f75f98f5d8c4ba0825f1318158f09e21e0aac316e24012afeaa4cbc5"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.9.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "5d0c8463ad42837f9c67859294a5dabb42f047c3dd755b1228a80f8f6a997717"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.9.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7553cdaf6f37ee93d58bdbb421532966ea0bb17ca1f4bad5c30ce75aafaea3b4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.9.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "04cd8a9dc56d045e38ed797aa465357d9fce9656268231444bd4307e2b285d8e"
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
