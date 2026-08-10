class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  # pwtune is Linux-only, but Homebrew needs a stable `url` on EVERY platform just
  # to *parse* the formula — with the url nested only inside `on_linux`, macOS
  # sees an empty spec and every `brew` command errors with "formula requires at
  # least a URL". So x86_64-linux is the top-level default and `depends_on :linux`
  # is what actually keeps macOS from installing it.
  url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.3/pwtune-x86_64-unknown-linux-musl.tar.gz"
  version "1.1.3"
  sha256 "f4c256c4ef3f6430e94c1026361898466bd385b31457cca3e5fc09696e921e46"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path above.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "368e8e1f65110ecd207974d3ffcea87334053ae27ffcbc6066f7c570eeb7d43f"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.3/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dbed0db9550697a7c2f34eb3885770a406a63de9e997ce889bee0e3525be3ee2"
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
