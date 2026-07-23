class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.17"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.17/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1a7e5ac7d939f528d49d3ca95296b9afd76de9e0a9afba7b9e84eb7e6389573f"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.17/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "22563d253ca9edd02c2b8fe96f1aaf36bc97eefe26707030ceed35547e6dcbdf"
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
