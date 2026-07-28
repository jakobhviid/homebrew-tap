class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.24.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.24.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1e34e979f305e6cb0864a0b5739ae834fff3aaa9f3ef3a3a79ff517c29154cb7"
    sha256 cellar: :any_skip_relocation, tahoe: "920499b0f6c4af75cc6fd4db656972fa6fea594363e76aafffa1c08ab04451e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c241ef20f657e28b2b8a4e48567c51328e021645cf8a43d0ff2d0872524e1f3a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "5cf98cc57cabb40d1eb91d93041d88e4ecf5ab2c1f16b29c48489162be13ee51"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "22f4956f75befcac8441ab224118a55df35c807f5a284a821e08b55a0f1b18b8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "29551c0c43dbe4be1a184bdf026971c9338bef94cec80503ee2de5b056140dd8"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d21286a9125994d9c1f6b77b66f66fbe7110a2047675e3e8828d82144b0c51e8"
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
