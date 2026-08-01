class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.3.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.3.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "70f300fce00880aefa2edf61554b3a7597ac5494c7c1e4454caa34e88e5b10bb"
    sha256 cellar: :any_skip_relocation, tahoe: "705a0f7bcdb7b3429ca23bdd35ebc37edd57e450b960196d9ba71349cb185bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "387dfb41ceb0302c56c56facd6551725dd8cb0c268ea8edad87fa575d680f963"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.3/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "5e9db066dfe4a66dc80fa924398ab78b1a5262a3efbc0aff966ebd4ccaf3f913"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.3/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "21ab37015fdcd437412df989e5bd1af6ed35d7ffcd1e71df57dcc47f9dd065e0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.3/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "16b7fd067b65d2b2ebeed5228b730ece493fcccc038ec6b30db6aee5e1647079"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.3/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8a0a35121a656cd474dc4bf5d97199c956fab1ce885f01822897ba97ac0f7580"
    end
  end

  def install
    bin.install "amdl"
    generate_completions_from_executable(bin/"amdl", "completions")
    (man1/"amdl.1").write Utils.safe_popen_read(bin/"amdl", "man")
  end

  test do
    assert_match "amdl", shell_output("#{bin}/amdl --help")
  end
end
