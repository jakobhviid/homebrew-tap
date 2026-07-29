class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.38.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.38.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "128e487c3dcb53983b6fc6a70d06ad4acc02d2335294fd5c26240568c82e894e"
    sha256 cellar: :any_skip_relocation, tahoe: "0a66e7648f829d355d0401a6d936a8bbce883f79e1216d0562379ea984d8c6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "38b5943c99ec082195662d51c348739093856ed167afd7dedde2829916e86103"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "e53d550585fc8e6c3c87682c89d49df74d90576b652c31f22d913acd74e793f6"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "16d94c2d6214006f28d80301026df9611e91a74cf031af1f99ebb86cda6116d5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "89bce51a410a75cb8271ce93b39e15b6b23a4427bd2ac8afd591b0ddbeac0c14"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5eb158daff77c9a7a475b4e619cc05880523799bfc22edb881cafd71eb78f599"
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
