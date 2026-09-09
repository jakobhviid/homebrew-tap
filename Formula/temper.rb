class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6a8dd25dc8eb34ecf2792ea9c06e140b910b267e164ee752c49098859dfa252e"
    sha256 cellar: :any_skip_relocation, tahoe: "b0e413823d7b25ed6229d87d9b3ef0c0893b16f38e42bc9c5c8dd0df19fc9efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e786ccf0e156eb70b31e2bb5da4755030d1f5cf6ac50c178c81f7e4a0b0e5364"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "246dcb7b0e614f4f4bb00c92126572680bc02a77470f5b6f4a40fe9b2730e319"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "522ea709f879e2d6beba96a2b6258dd2657f829d83f899791683a1469409b473"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c77726c9eda758297e2092b157668a02fbccc9dadae32a1aacf71ce1380926a3"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8c1ade802249fe3fce0940c5c680fe23af088cc1c9339d05b82abb96c86b85d8"
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
