class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.9"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dd2c5077f3f107636bda24f21202594c5db042586881c8ee5f242b7161ae0f18"
    sha256 cellar: :any_skip_relocation, tahoe: "408620ba5ffc6327dbe209db3d97705285840d0eacc3dcf3ff33851090d754ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a6e775f5530d123f4695d311d175bd8d1e5b7433869e3b4fbdf3aa8d11d1a298"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.9/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "460de3a4afe88b415c6416b93270c4550b4aa1ee4d4b789443c32b810691f77d"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.9/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "626a453a4f0c49b5667e729d0e72ab593383ec804e7fd765e1bf12774dded71c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.9/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "40d58c0cd93a8eddc28d3afcf97327f730807e242734ec44bdcfe68fa84626c9"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.9/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "83810f77a320ccbe7820a4cd18f680ee88fdab7c3a56d326b343e3503f8b4f3d"
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
