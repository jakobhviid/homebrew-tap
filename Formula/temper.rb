class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.24.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.24.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "af8bd6318cdc939df2f43a333c03557167fc42841647c26d1151114b51c57f54"
    sha256 cellar: :any_skip_relocation, tahoe: "cf0cdb5d2f56d0b0c4d8bd75610308e3501c2295fac8a0820dcee375fe3b2da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1635cd8acb2febb9142f64e5837cc8d194d208ac1c22901233d89ad363c22177"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "dab0e65b1ec49f94ccf5c29870c3f56eda690c6125fffec0750a7e4e215a55cc"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1d6d3e6dec1c4639dceb22b21e2e9cc92501e7500fc24a1ec9b611a4998786b3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a2c86fa8f2834ed9426e1d2e61057c76c7dc742aa8677fec3d35e086522a356f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "28813fff697550add2a1c8d08487c22094a245bb278c734ee9fc9b6e651dd06c"
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
