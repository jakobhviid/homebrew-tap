class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.12"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e24054be678f5c1c90900ca481723c903220265a8c86b9906bd50d9bbf264207"
    sha256 cellar: :any_skip_relocation, tahoe: "c570663bedc7c25b218870d439e0ec9e03f66295cbfc6a0dc00026bc016910e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "39a2cddb6f6b7c1d56b369522efa8a6213af84a4e228a61c49f702da2f2f8c83"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "084a64a38219d50bbbbac988959bebba2786f759ac9304c43dae8b827dc20022"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "4022377038ae0f903fcf33b59fe1a17474c51e5fcffed2e7f5a94152d7257a5c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dcb779c0f7de38c90d5ea563d0b57a6925f93b727c00047543d27e2d2eb99b8a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4bfefaf60b377f52f383cc206d8019d68c4299da1566affdc86015a13b47f778"
    end
  end

  def install
    bin.install "amdl"
    generate_completions_from_executable(bin/"amdl", "completions")
    (man1/"amdl.1").write Utils.safe_popen_read(bin/"amdl", "man")
  end

  test do
    assert_match "amdl", shell_output("#{bin}/amdl --help")
  end
end
