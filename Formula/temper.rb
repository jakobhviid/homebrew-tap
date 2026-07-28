class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.21.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.21.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "bf3385c59008bd69a9af8260da85dc18aa49c4a8cc50a44489d1c87d8fcca8f7"
    sha256 cellar: :any_skip_relocation, tahoe: "df747b4025514c860f6802d5c4e0d1702cf9f8b3ebe8a44baa6bd118fe1e32f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2869a8b2ac8a24249d0c7ceaa0ccd09516b4e21cca05c9167bf5f34a5d665311"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "d77386fa300f4a103a700259f863d91dfdc53ed74db840167d8581653a4fa0f0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "675a86f1586a9cac10f216dbecc7d029d703d48df178ce7f3a6d8a3b433e33f6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3cea671e7d9cc189f4982486cfa57bbdc5cffebfec11fe73f584d11a71c7f3f4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.21.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a913fa3f0f5b8a723b453d4407414e6877f212d4d09e73047e08a0e8d876a4fa"
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
