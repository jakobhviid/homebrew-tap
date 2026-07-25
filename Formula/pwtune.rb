class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "1.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20a5ebe56aedf635435d3585aa7e9f1b92ef8b12336d0287fd74c08e782f1673"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.0/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cae53da88ba0c6588cf39c405767294a6a6c80b9768ee90b231b617c5dd47967"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.0/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f3469c7c8bbb156a6276205fb5d46c34f6ef7fb21b2f33a55acf0f9db63956cd"
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
