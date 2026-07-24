class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.21"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.21"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2c25d12a7394dbb80434529bb676db82066f5ad62302c88ac4a36680e3a06e5"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.21/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "37f8f081fce7591f7a0c2eb2a1aaa7a0f592840cf49fe48689f2fe91f90ca869"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.21/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "69e3b9e423f3642fd9647c10329b22acf133a72d767940de0916c79e3b239816"
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
