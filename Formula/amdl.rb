class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.8"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4e0241906cee0ea9532e58eb69f10f818b4272652eb856e618d08b181ccce996"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.8/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "ffa4217e3a5d26f20883a99791a1486b7adcae62886f6a07f6bf8c7967c20bdf"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.8/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "e524d3112a0accd1a83cbcca801c21ebdf2cc182c2752ab56198207c471e3719"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.8/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fbe7c63eb264c96ac1e5da1d030300a71994513e2c28a2e99725d1cf2c39ac28"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.8/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3cb60b442cfbc945acd92e6f9974eef86bf071482c6c19ed3671aada46c5eb10"
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
