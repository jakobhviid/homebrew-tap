class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a55800143cada6e0e20bd36437ce0f1a926adb880d962a23eb13df99fd08214f"
    sha256 cellar: :any_skip_relocation, tahoe: "a5f4f094a1d0aa8156dd57bb38b914ed30821e1c9b03f6ca8a85a099b048b5e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2ea194460611a653a6ff898b7fc246ba0e9720a5cddccd59f0f5a7b47d69b391"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.7/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "0f7d513151b01d6650c2222a87c14cf6796603fc1327fe88f44191469af0d617"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.7/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "357ddb825e3e1be646d219fcdd56d78438aa0a9f2f8166ede0861039899ad708"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.7/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6254cdbc614332a4cec6a9f267cdb9f4bddaefa88e0283d802ee624bf8c4434b"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.7/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8c09496d283c97809444db9d2484a51c780638364e222466764a647002c4265a"
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
