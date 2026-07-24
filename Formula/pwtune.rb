class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.22"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.22"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4030b03d12cb1d53b2d43a163138a554099c9e95fe066671693235ecbfcfe6b9"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.22/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1da5b965203a611a49621e176bc076e269f7d62af1acb17526b4ef3e303a6b4b"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.22/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c943940a040ac254730ad891b07dad9292527b5363119719b0e715f3c0d74d38"
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
