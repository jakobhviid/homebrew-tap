class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "0.1.24"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.24"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a8222db1353fac698f305d1d63b1c060ee95a258e54bbd7ae9c9cf03ef6c3b28"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.24/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dc01b2ad21255fb8ae02224df2841544d5e98bbe9ba4527dfac1872024400249"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v0.1.24/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6a4d7882d2f696362f40bf40ba3a7f14a8e196bd460f10e8dac12b5c3ec701dd"
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
