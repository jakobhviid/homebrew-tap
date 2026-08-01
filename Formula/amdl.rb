class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "5.0.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v5.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cfb742fbca5066b9da28b5bda048be49b725a50c976287f238c0874c4d83b8d6"
    sha256 cellar: :any_skip_relocation, tahoe: "d164351409776d80f889dc02f9939f9b4be13442d4b2115e76b09d845a65fb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe103dcab04ae74407452e2c23ed89881d17d28cbc199249592e5c2a1414ba59"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "934cab1be0eae136682218198f2632fbffa220f6024b5c6bf6cfcf049669bf7e"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "318c6416fc8491e4469f74b5ea70dd205477652bc9f2d82d11ccc1bcea16e9e2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d20a068bd61c05ec380f47d839679daeb2dfc1cffd9a55249598f028cc9efac0"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6ed32e532fda087f32b34d64627f152bb25c771aacf217ca07ea8ce30f7b968d"
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
