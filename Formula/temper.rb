class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.1.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4707eafd13adfec788f4194fb6cec95399b67618a8f33d3df49e98b91de3a5a7"
    sha256 cellar: :any_skip_relocation, tahoe: "5f0a65395d65d6491fe7f31b1a2b73f4ff5c959dda8a9b27cb8eee16e65cbff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "485357fde7dcc28477ca321428bd4b062f0dae9c17cda81c4889cfa751b3ec81"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "614d75cb9d6814c7aa19b1b719cbd4ccaac896eb701cf0fe0473913e799cd5eb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "67866cad320c36156d16dcecdcdddf7bd5501c6d603534499d0b03b001f24d49"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "196305c10f1b3cbb0dbe1f8c06df043779a330e93d913e5c77143737456596d5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bd7ec7fcc810fbb2d0ca362be7b5a54ef6600d12f92174747f0bde6ecbf658c3"
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
