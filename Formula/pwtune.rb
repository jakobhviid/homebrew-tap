class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  # pwtune is Linux-only, but Homebrew needs a stable `url` on EVERY platform just
  # to *parse* the formula — with the url nested only inside `on_linux`, macOS
  # sees an empty spec and every `brew` command errors with "formula requires at
  # least a URL". So x86_64-linux is the top-level default and `depends_on :linux`
  # is what actually keeps macOS from installing it.
  url "https://github.com/jakobhviid/pwtune/releases/download/v1.3.8/pwtune-x86_64-unknown-linux-musl.tar.gz"
  version "1.3.8"
  sha256 "35ff4fc895d2ccb737ac9135a8a1b73e6e81c1e08186e8bcc37f00f98041735c"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path above.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.3.8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b9504c753595de6898512d3b67a33fa48a534db44708a7e0175f7978feebf5ac"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.3.8/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9c1df23fd5188b293531d6bd90650b6125a40715a95c3efe8e8b9e065aa692ee"
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
