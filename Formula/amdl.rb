class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.13"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.13"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "afaa82880890c3175fc84e986d354921487f6860806f3f2fdcd1116f85d98eba"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.13/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "c4e3031173f4e7348dab6039f38674e37fb8729a1577f6452013d6772f4263cf"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.13/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "8e87012bb07ebfcd9bb90fabc4d815841e8cab19bc3c7b6feafdee6387ad8a64"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.13/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1365e1cb0f80d6d3d72a438b7f05a0ad178a09ff6ce88d2c77cbeca6db227b73"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.13/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0281df75706def04d045633f0280923a86a6e4e98dcbdddfd6e5b80ab1d7a24b"
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
