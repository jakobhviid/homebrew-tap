class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.4.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dbc658f739e7be9d32a3f5c4c740fee2512cdee96c2401a01149718d43d40668"
    sha256 cellar: :any_skip_relocation, tahoe: "03238fef9d3fb4d0bc5989ab6f217f3a4fb515aa3bdbcd9dc98d94acd03ec173"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a8bdf63cc99e19764ca129a7453d4cc2dfa5b3fdf6172c60f47470334cd3411e"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "66d185fe30e1e5970185a220a96bb5ac5c06dd67fd5dfd8d4dea0470d0884be4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6eed3a4b1bdfbf7cceff56a2f4b841450a3d7c43b46c880bb4b0b9d8049cb644"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "498f0e3248d25413cf55e8cf499a2c281dfa8cda4e560ab790e7ef9ed5d05001"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d98583210615b79916f9f222da72bb77bd40927762f49cf8f2769458128c780e"
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
