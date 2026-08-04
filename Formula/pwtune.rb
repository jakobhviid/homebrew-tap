class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  # pwtune is Linux-only, but Homebrew needs a stable `url` on EVERY platform just
  # to *parse* the formula — with the url nested only inside `on_linux`, macOS
  # sees an empty spec and every `brew` command errors with "formula requires at
  # least a URL". So x86_64-linux is the top-level default and `depends_on :linux`
  # is what actually keeps macOS from installing it.
  url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.2/pwtune-x86_64-unknown-linux-musl.tar.gz"
  version "1.1.2"
  sha256 "0dcff932e5612dfddbd0c4781402989bf019924bf13330bc8ba43fc760e0a381"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path above.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2e2a3214a2a7f79c866a1e866b912de4c7ebaf40b06bbb82c54209afa9c492c0"
  end

  depends_on :linux

  on_linux do
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.1.2/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "55518cd408cb8fec191bf016240944c24175a8b6b203e76041baf32145f88705"
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
