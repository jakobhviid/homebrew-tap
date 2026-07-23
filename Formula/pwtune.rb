class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pipewire-speaker-calibration"
  version "0.1.11"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.11/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3e240586bb423267df26ace63f0d28a5c0a17bc17a2cec1f83fde112549905f1"
    end
    on_arm do
      url "https://github.com/jakobhviid/pipewire-speaker-calibration/releases/download/v0.1.11/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1745aece6d9ae4d9b129b54b160b6763cc0a145a76a01a53950713a82f4e0e3c"
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
