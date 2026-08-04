class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  # pwtune is Linux-only, but Homebrew needs a stable `url` on EVERY platform just
  # to *parse* the formula — with the url nested only inside `on_linux`, macOS
  # sees an empty spec and every `brew` command errors with "formula requires at
  # least a URL". So x86_64-linux is the top-level default and `depends_on :linux`
  # is what actually keeps macOS from installing it.
  url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.1/pwtune-x86_64-unknown-linux-musl.tar.gz"
  version "1.1.1"
  sha256 "fce09e8a5a389f45a8534a98cb726d926087464184312b45c087a8ee2c33b988"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path above.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae1233a124352a506235dbf89326614b57f6b9f84c157fb093c7d6f3ca63169b"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.1/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8b50ab98443d576f9ae7e9fa6023926a1a65f2962ce79d74f8aa4bddae6c8f86"
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
