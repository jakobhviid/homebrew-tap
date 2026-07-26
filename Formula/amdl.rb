class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.7.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.7.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ea45ffa547384811043a9b7685d37d603b13a8581494627dd448be1826432e8f"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "26d7088acb0124996d1c774b58d19a53961b0ad808a3b3a29e861c4051d46f31"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "1520e84bfc2496024bdcb6ae7c348b85005960a22629ae127f883e61ba2cb78d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "75dff02d70d7044d5e8978181e662677a67eb4d7e2c26f25b74e2a31f6f7108c"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "47ee378db521f31cd4b33db6ec75a0ededb54ac6cbf68bf69da5bfccfb8576b3"
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
