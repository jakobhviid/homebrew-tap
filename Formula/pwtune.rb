class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pipewire-speaker-calibration"
  version "0.1.13"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.13/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7ef5e135787dd21f27256b1ebcc973bf99ed64070b2611d5ccac26392506aeba"
    end
    on_arm do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.13/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4030e7db80881203bd11a51f8a9c2480640be0d4e1b5250c056c1053bfe6dba2"
    end
  end

  def install
    bin.install "pwtune"
  end

  def caveats
    "pwtune is Linux-only and needs PipeWire (pactl/paplay/parecord) at runtime."
  end

  test do
    assert_match "pwtune", shell_output("#{bin}/pwtune --help")
  end
end
