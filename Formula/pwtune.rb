class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.16"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.16/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "553d8b2fd41bb3b2e788fe9f07ef89c37c0c2189e09a7ad39c626c6a55e73c64"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.16/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "47fa344dfce3675eb593f776161f7193576d639c76fb4c8c92a8a26a9e27f118"
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
