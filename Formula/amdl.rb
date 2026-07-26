class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.11.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c204129a81a54e7ba2002c5c5fd6a6b761e8e17ee3baed9861779f0147fad3c4"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "e05ddf6c194251461d734312a12a62a33b3e64c187db656a2ae3998645de5877"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "d8595d408a5faf5d4d62d76d5c0fde8c36b733ed44f4a417e3dda74512964c8f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b90d6ecaf82a436c18f2a7375be2f3af6a3f01b398b31f579f1f0587aa9d456f"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.11.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a7136453e82a4280beb170437d57824be8cc5320b014c9314df71a62bff1f8b8"
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
