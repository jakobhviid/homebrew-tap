class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.7.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "11c2922d9f2736620f2d783bb88deece7db393fb0f1bf83e6f57f78c142c1ef8"
    sha256 cellar: :any_skip_relocation, tahoe: "b79198148b7ed44e1dbeb2268127e83c2723d42664a6a8b01cb67e75cbbc71a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ec48cb74ad535a7018fcf4ed34300f94eaab188c8075d5eadddf89358c26ede"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "df2c71c62c9152ea16fc5f5afe0748c7f3f96be1d3e4b113511859318121bac0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c00d0cb9012939c4aa5fcfe647f997c8a9f391b4c9574b94c16a4092bc7a1d72"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fc2a00fc0b9669169691a8a0ec7cfd877b55a77b2e6c04cc394c8df354420668"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.7.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "138373b7d09c390ce96d6f6fe534c837e7d49ef832dffbed659a802a8ac6b869"
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
