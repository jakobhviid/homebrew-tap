class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pipewire-speaker-calibration"
  version "0.1.12"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.12/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "59419fe71177da4ab1c7df52675b55ef30c17f99fff08a0b7737a63b1ab39010"
    end
    on_arm do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.12/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "75dc3d95197f84a2533bc3f9f10bc5881fcf180e5d283189d48c6d7467b8b0d5"
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
