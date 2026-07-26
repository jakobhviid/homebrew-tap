class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.4"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5349eb8bf4ba491399548a46fc0eb83197f60c86fb0a17c0140753e19c1f6ade"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.4/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "15a6b8605a8e1154d8856900a78800661f40465f5d56f1b636c2c8b7088dd452"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.4/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "0d04d5d3b349e70657a8a9333e3fb52943cd69406ca5d412b6d3a4e7f7f7dbb3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.4/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b39629838ae2816f68afdc4ab10e5d30811c6186fcb35d4884e6c4d7fa47ef51"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.4/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e62c9b344390162d09c65a33624f790a99effb1ac4a3a8dbc4c78c2dfd48a713"
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
