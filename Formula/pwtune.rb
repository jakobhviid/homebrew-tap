class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.18"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.18/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "52905c4a7054fa2aa8d9f7c3aea03ffa896fdb94290d3bfdcaff27c93ae501c1"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.18/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d613bf0ff6209d2ca2d3d4e4bea6a5c2acce40e435b2cad12263f8fe4e833d02"
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
