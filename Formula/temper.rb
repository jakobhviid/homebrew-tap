class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.4.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.4.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ffac07023830a4961938264312199205230765efc4b72f3ac6fe20732344cd15"
    sha256 cellar: :any_skip_relocation, tahoe: "43e0a800d8718f03fe216a47d365522ee0cea19e3fc549628ab526cf3a0e7074"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "78c91aecb7d572e7a6615b999fe422646c28cdf50a065a6ac2f5a7c2f842947d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c62cdecc8133a289c177a6050464bea1be07adbaa8fe685c5633b38abe31c760"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "830b20d63dd289f627a0ce838340768e82754171f60a6497ff5e71ca52f197c0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "86ac48ea929120eb08dedcc91eca8f6a13c9dead09496faa17ee07c523ddb80a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a56caccfe384d2d35297f51b96c5958af5ed815ee05afea71e7bcc2956d0a56d"
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
