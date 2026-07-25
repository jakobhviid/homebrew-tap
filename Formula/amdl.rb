class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.2.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.2.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "11da976fa705260ae67f5ca612c80b1c46a3d1ef6d304a9d503589ae8bfef3a7"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.2/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "2a01991d8929639ad42d7e7fef1398ebda24d1b56bef60fc1729b6d20be0fe99"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.2/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "dcf32d22e2bf67bfd5759ed293756adbc61acf7e432d4b2c691173ea287ecaf5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f402c5df6743c5c1cfd2cf94a97ddd20f3bf00345439c36a4417cec3ab6417f6"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f4820c9d57ded0cebf8678384c5ecd14121ea3d4dd28524d186eb12371296163"
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
