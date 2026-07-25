class Pwtune < Formula
  desc "Measure any speaker with any mic and build a PipeWire EQ profile"
  homepage "https://github.com/jakobhviid/pwtune"
  version "1.0.25"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # aarch64 falls back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/pwtune/releases/download/v1.0.25"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d275f8c1204f1e9d43baa90736a7b0462054b06a607ff0bfa0ca73d8e5c8614"
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.0.25/pwtune-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b3394ed499d16b9f835782449e57acc2dfd9e82bd550e8886e52bf04177473d0"
    end
    on_arm do
      url "https://github.com/jakobhviid/pwtune/releases/download/v1.0.25/pwtune-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d6e376d36c899ee616b4eeb4ecfced30ab5cedbfc17a689c06f55f74e9dc9392"
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
