class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f4274731f8d95a1039f8bc639b505597db65ff7f9b9fb7bed8cbafb36fd04301"
    sha256 cellar: :any_skip_relocation, tahoe: "97a7ba1579a0bccf2b8485127c1f65b42f733f0ac806f57514d04c55f0efe51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ae584f3341255b6d4f0a2da3e108e1d909ef3100d1213adedb5405423110ba3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1dea66e218e8d69055ed54cfaf36d82497b011326258758d84c0e028b99a912a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6277c9ce5d7f917685e5a223483b9c20f9fa163d86f7b1fd3104fc217e98f196"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "34c338912667dfb98287b1e2c4beaaeefd67046014b32829c37806170003e0d5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "775858c7196a856fe0f43019a38d383fd99822c64bf6e820e26981af5125168c"
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
