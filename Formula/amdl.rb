class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ceeed59b1fdd9822a7f3c10d122616b1e0aae1d7b0f125ca5a836c23f1a9115a"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.2/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "8f3aef30cff879e33358cfaacd04a054bf5525cfae410b33ee8bca887b0f857b"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.2/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "dcc94087800bb0d55f53f3507432bdec49b3f62be8ea93c42e47db53e10061c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "240156494e60b93a9d1bb325e3f2d6722d3a6761d62337a54fd532cb5f802701"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "33c82d4c27bea3aba7acacd9ebdd3bffc30a59a2e26344276103700aae5a5e95"
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
