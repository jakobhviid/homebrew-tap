class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.4"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1d7bae1ba919f1ef8a4803b75be1487bbb986c3db99f36a0bffd65d3d9b54fe"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.4/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "62166da11de90bdfed8a884d03685b8edad917d661865b75bdc4eaef7d36a722"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.4/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "c7ab0c75f15fe739b0d756306a5bebaa27c10d8d6ab76edeeaf34ae4d070edd8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.4/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "08a9bb319cc7c5e5af4105de6719f42ff4b0d4a608126011e0a1d625cd574206"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.4/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f5dd7502c20cdb9388f87e7df1f576561de9bca13a80a045bafc9d5042eaad6b"
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
