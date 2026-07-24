class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.20"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.20"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e8d9c43230ce37eeb8b516f2faeb07e8e6ceb545bf4764e1a1ad4f2e462fdd7e"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.20/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7d298eb5df8992c69b8aa8a1c40db4b5e7eb69f5bef1746039058794e03f10b8"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.20/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "468737e8c1adc97f4c7b6f6270a5a5d96aeb136851e246031a33df9d730dfbb3"
    end
  end

  def install
    bin.install "pwtune"
    generate_completions_from_executable(bin/"pwtune", "completions")
    (man1/"pwtune.1").write Utils.safe_popen_read(bin/"pwtune", "man")
  end

  def caveats
    "pwtune is Linux-only and needs PipeWire (pactl/paplay/parecord) at runtime."
  end

  test do
    assert_match "pwtune", shell_output("#{bin}/pwtune --help")
  end
end
