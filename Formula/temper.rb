class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "58d06f0ea716ca1bff12b5a9b3aa5549a302d9d0b541a75a7175d4af16374383"
    sha256 cellar: :any_skip_relocation, tahoe: "dbc8253a7b4015194dedb1635f56465ce1489d5ebdedd25ef28427e126012fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b9705249d09e2e65de7b08ee68c090c6bfc94f792fd5f860d2dd67f0fa1d072c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "d4a7d8072a72c5705f9b6c860dc22bd783f0da5e122a2d404ad19abb2081b2b9"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c41a857e9a92f012c9b9a9baa4c7941adab28ae25926bf4ade4183583db357ce"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "46c43edb53660d9981a7f725fbfe3a1ae9b217f5646ca013b60c5e9bd93207ff"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fecb136d50dc5f438e05794a0fb12b66d6289b8a560f03f2ded6e1d03ed98a6e"
    end
  end

  def install
    bin.install "temper"
    generate_completions_from_executable(bin/"temper", "completions")
    (man1/"temper.1").write Utils.safe_popen_read(bin/"temper", "--man")
  end

  test do
    assert_match "temper", shell_output("#{bin}/temper --help")
  end
end
