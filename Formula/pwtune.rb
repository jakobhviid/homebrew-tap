class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.15"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.15/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "67c146d191d74abf8148cbee062ffab28d55fa24d2a3e7623b2af5d07fc44a71"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.15/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b5a814a91c3bfecb88afa3c69225ea8c72f3d5ee6bdea4b4c4e51fd638efd857"
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
