class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pipewire-speaker-calibration"
  version "0.1.14"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.14/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5db9da78a6df01ef954fdb704bf6a851346886544712b30092432625e936bea9"
    end
    on_arm do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.14/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8b1c096316f2e4af50d991ca1c8007e2f095cc65cd663836ef2bb7722ee594ef"
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
