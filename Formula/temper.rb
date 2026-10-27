class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.8.11"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.8.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "32cab17c5c5e13b8ff213d2706a7d77ed1d007f31c615e3525281ef623c4b919"
    sha256 cellar: :any_skip_relocation, tahoe: "8c359870a9b2b578fb9c1beba1020ca58ce870b1f725d43e9dea1de36e590456"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d8ceaa5694ebff6fbdca082e8e74e66b932f189e9a098460b6acf39a80a4dc16"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.11/temper-x86_64-apple-darwin.tar.gz"
      sha256 "b4ab6f0002e19837d2d715af3d1a730d58bf24aedb52627ed9f42b5b91ead7ea"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.11/temper-aarch64-apple-darwin.tar.gz"
      sha256 "a707ae4b8688bfbbffa8d905bc15b3e73fba2a5cb8019d8b6d37740de09724af"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.11/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3e52133a81ffd3e0a8916ea803b865a99511be9161400e60c81fa4936cb72071"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.11/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "664a6b289a76f797d4587e913334445d4084c4970c5e2f9b3a0cbfd00cdae1fb"
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
