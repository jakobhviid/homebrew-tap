class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "2.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v2.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e63f3186fbd7f7d3ee0f93905d251ba727c928caded5cb013711511a15b2d3ad"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "341c3a4810ece047b8905ba4fcec5a9f308122de81d027b097d1719305ab9abf"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "ed8412679f046c400ac619be0e5a45087679b2041ef8e47876875feeb0ddc717"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a12c373b15cb64e77b1a4a3dea216bf9d8d93fdc8eec8ef97c0e72c31c2fbf0a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.1.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "be7efdcdd346b0c74163930c265e4e23af6ab18ce4154e38655b73ed0c09b3e3"
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
