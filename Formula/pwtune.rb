class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "1.0.26"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.0.26"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f142800b8e3bad9386642c010bf1fe496681565134af32aa5258fa303469abb1"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.0.26/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d4409172bf79ea8fe9f50ffe1f28d55037e5201586da4637f072ea581edf8226"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.0.26/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4f666392ae123ff1659eb8177eadeaefaabf3bd0ad9fc21fa8c448b80525f982"
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
