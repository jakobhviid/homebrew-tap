class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.10"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "faef779505deefe030d0f3e3494e9ac55e2e3bf274d7931d48fa278d4d35c587"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.10/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "bbf58299e244e29973ad40568c933f49f8f200c7fefd5c5a1a2dd2fe260a2033"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.10/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "44140ff69b869fca7185f9366e1932621235ac9a9913a5b350eebc169e16dee3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.10/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2763aac7fdb53111cbef8cb20fd173064b7eacc397b88316a9939f1787892094"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.10/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7a7723087266b191ce0c3ea3973394fec40f8f872b351ee6cb4a4c4a2b15005f"
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
