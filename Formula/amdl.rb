class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.15"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.15"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d8af6088078003749a7884812d6c7cd0cfe297a741db95525a8ee54dea3dc1fa"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.15/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "6b1c967f49e8484a85e08bb0fab1cf0d8a0d2d91708dc6aedce0a21d7c36432e"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.15/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "879aa2db6089c0183fcc7b0038fc736452ae7305246046c673b40fd26d35ffd3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.15/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3b1f2b5659f6f51b2a69f796ab53b8bd7addadeb5249228f192322f547a1a332"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.15/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d19004178c70383d2277642a04b4e74465c17efd042d8cd268fe0717db38b571"
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
