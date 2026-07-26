class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.5.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.5.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "253756640a8973b680f2ce1686c917910826949e91bf001c840af86ae38ddff0"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.5.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "f20431ebb794dcfadb35e92a7de12c30b9776882d2ff205bb5abbdb07882466e"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.5.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "b471982226319cf705c8e7766fab11d783bd4c08b537d84666c3294cacbecb4e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.5.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "46ba3be0104f9a447ebd0e274a7720f0a8361bf6f96add2c20c373dc34096881"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.5.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3aa59e80961508630bd1c68c11765371ea9d9216526455ab396ff807165734ad"
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
