class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.8.15"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.8.15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ed51c61fd97b8cd643585aaea3c545cb65d916dce1ce681ebf04be26e665e830"
    sha256 cellar: :any_skip_relocation, tahoe: "99babe7b22d3ed2eef114696b84112670f682319129add9aecd77616ba6630f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e884db558a666f28a1863a0f5a228b4dca7637b49f96499d74c054f3c60b86f9"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.15/temper-x86_64-apple-darwin.tar.gz"
      sha256 "ee705edea1e523c7cdb21b466e5de00aa3a6b9b16c01c668968e71fc334a9f4b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.15/temper-aarch64-apple-darwin.tar.gz"
      sha256 "820218014df5c012c7cc5d7abf826584fed3eee51056a5d11630e835f600a061"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.15/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e8afcf88d7fe607446718e3e7455d86787b4d5a7a16b70b819dbdb8793f9d101"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.15/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "54446b74a1525120494e4d343b41fe35c50cb8a6c0c50dda1246057e46b97d12"
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
