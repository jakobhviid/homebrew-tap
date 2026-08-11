class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2b8d5433fe42b975d89c55ab63e2c6aeca018b08604d6607cc2479e6af2744e4"
    sha256 cellar: :any_skip_relocation, tahoe: "2e2d76ffd22d51dcba214772ed2b884a8a2160b92b9dad163f45fafbac7c9251"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "02c04fd43c7e0ea6cc2c78147f253fe83c4e26ab0474ed0b27d297c6bac1783b"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3e9f53e617f061f1e19ef358e41c73a359931e07615a0aa7907000838a8665aa"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6a6b7e41f37fd80424e3885d987d1faa42b7dd7cb44127b1dfee26cc845220bf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f27aff0eeb0d0e49c0c4bbb3201f0c7421010abd50c8162aa29cf7f56b163218"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "856226548a119a6863290bcdda780b0ffb73e6133be28dd087a281ea7fd59116"
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
