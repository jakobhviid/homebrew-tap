class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "956721d6072832cf721847a9153238a710da2580feabb3a4a49ba902a1c60d61"
    sha256 cellar: :any_skip_relocation, tahoe: "4c89e5f6bbb732e2666509680cd8d82fe706e0bb3160c4e6fb26ec5be54913d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "67a2761e5fb8f64ea28eb8066c8d15623c2803a0a651e53dc41a6ec44f02dac9"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "45b7c348ecae459c59aac8d7f302eb303131c0dc3326bdd78cd8745f21c5580f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1e5a7f7d81fc1c5d328b81f624184c27214963fe8e7af213bd54733a45d6eddd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3d40142b1521aeefabf07313ec084e8be1150bc47d4f9dc90c38b405b12ea8ab"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c0cee6a0f90da7de23e2eeb2b6090055271e5ab026380f603264fa0cabb96c62"
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
