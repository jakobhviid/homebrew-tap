class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.7"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53502249c70400d374dbef7ee66559f46041d304ada533ab68efe14eb4593cbf"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.7/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "86db2d492aee3cbb479d5d394e7134cd1c8cfc011108d2e9eb9c1101ca2e0711"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.7/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "d35536594ae1e834fad29dcb642ee2a8ff6014a78e09d9810454a9df6d52ceb1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.7/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a6c218963c759e1c90178599a1d173e50ef26a5adf2273e60c23318cf7f7c4e7"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.7/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "58ebf422e1d00f3536118705b5947c2781f52c04e7b4a2fd419ac8307c65e0dd"
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
