class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.8.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.8.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0cd52bb4ee6763c06f35e6e86ff3b565fed804628cb74b68793b5773da6203f4"
    sha256 cellar: :any_skip_relocation, tahoe: "b5d5d4f81cd70c2a627bd304b5ab6d687e1044a38094da5a90211bd4e35aeb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "50cf240c5fffc15235e333d8e9afbe6549a46c96819f327907fa77acf60d5f3a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "4d778bf139018a38890c8d2abd4a79f0af8e9b7b9b857d986ea83520fa448ff5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c03ceefbf1a76add91a26d0023fd0b4d73798cf3319c01b403b07b9e98a303bb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c79f217ef2d408760a5abf210f9ee400bfb3499f14bad11cc0e765a6467815f4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9e820dc99f6f6d961a4d48e28e7a873716541772a4e6b0acae8e633368cc4576"
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
