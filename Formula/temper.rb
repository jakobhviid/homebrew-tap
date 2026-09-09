class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.4.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "130d4e823c652db751b8680329ec2cfcf1cffe96869a4bea65a11c96d19af924"
    sha256 cellar: :any_skip_relocation, tahoe: "cbbbc2a79f286c40063c77d1503da865b419645f26722778bba876a937211a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0514cb89c5db06b419ca49404856471aed917c49329a0d5a3cfefbf69c30bc3c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "236b7adbffa21bf71842baa754691b6b12ca7140d6ca5189e54558594be374f8"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6fff15c3656ffde769abbcf81c0b5ad3f514236e143cc2417349c9007ed60b9a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "760c42eb3d6176f053c5e3b16e4ba87e7167d434abc90e9af061581984c90475"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3468a1bfa1e15d5e0110afdb891f7505e428ab0066b05797033a91edd0a58cd6"
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
