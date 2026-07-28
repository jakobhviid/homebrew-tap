class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.14.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.14.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "73c5f292bb59b177703c1306ecea6ddb7fbc16730ea6eb7df2d3410104cfcaf3"
    sha256 cellar: :any_skip_relocation, tahoe: "a9044d20024bd1a9caaed11b71b1c63ecf079adb1dbd45d6522e950ee15a12e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ad76cdfd19b30940dda87e15cf8dca9773aac1811df0bf5217f4479cd637f2cd"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.14.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "ff54cdaff49039ff97a0a53ed314b3a80f201ecdeb4dd42d79816e8f22e9e632"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.14.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "b1e18ec104a6dc0ef8d8d53f195a9a4faf494a4da6f8b67218f13372bc9061ff"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.14.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f5053f17f7e5a69a4ff70c06cde06bdc834419871222eecc0a7c328f2668bd5a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.14.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "33e7687a12629374f1f80e8a756add478b0102705a25a6388d16ba838c73ac7d"
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
