class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.12.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.12.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "07e40da93f264cd0b13df5bef6ed5a81b036365ee6dc23115771de07c4122b55"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.12.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "0bdcaadc66a3e4b07824d547efef06ecad7f8994541e5444eb566f04d7a0b20b"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.12.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "a77b60db45b1478aec54ba94625d362c3dc545c81778d819339317d671bb1ff5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.12.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "81423c7a154732acc597da87cd9f0402f384969b4e49030b9d08c9b19e6df133"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.12.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7ffda94b8c517790d5d3d655baeb6dfe2fbbbcf817878dbd635bb337ee8a38a7"
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
