class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.3"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "76299e810f4c21f5a9eb9de5edcf7ed3cb7d4032303d2029759b65035afd2e50"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.3/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "17f70ecd1d8168eeac0f3b5f59ad4641ce9e3189ed54718038f931b9f3210efc"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.3/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "bd0e2b079022bf1aad0aee2477bfe263d816614c3e1d6728eada552143736d25"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.3/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "805adce07816eace8e1999008f60bda820a1e5cc3a565ce1c3e72e00a3aecf87"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.3/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "26ac179a5790bded4273c81f12e5420e86f21c91197cf2c0aa6258c0d964feca"
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
