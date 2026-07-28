class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.22.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.22.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b6ac41ecf01615fbaa7bdb26efa4133b3b1250f8b88bf7be9062ae6776a8f88b"
    sha256 cellar: :any_skip_relocation, tahoe: "f25ddb6d55c18b56e28906bba2e0c39f194893640f4b3ab6416f16145e4a9883"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1405e0a27e71583dd0df381c72f0da68d877b8e6167bc303ac9625d41fe90116"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.22.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "138c8db38fddd206ea70ce15aaae752de1ab57b4d0eaa4f42498858242c915be"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.22.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "e490bcaa5633cd42e7167de3e4489a0a00fa02be3041cac70ee0c9d83f47656d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.22.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7785c8775e3efe14f51a37e7cf695dcec96bb7131e23f9f52e0451cef028955e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.22.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6142ba22d7b3ef674150a4269f7196fae4acc58b302e41637f5ca4c8aef5eb3b"
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
