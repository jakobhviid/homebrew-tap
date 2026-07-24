class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.19"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.19"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ef8a59ec5ca4f2bf30f97deb07563c7ee9e57288de9f17a4753912943441e4cf"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.19/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5c800c648f6559cbfa8fbcf1764a86e4b928a4ae181a4e7b88e69a51b2ecda8e"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.19/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b2fb6230b3e66c1489ef313b94b21779265794fb839e835f5672da9fd9ffdee9"
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
