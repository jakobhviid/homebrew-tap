class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c7927483f70f0f2e5c13a80e5aad62024902a5fa3702d90d8ec14e578722f237"
    sha256 cellar: :any_skip_relocation, tahoe: "99b13961dfc3da4d03c460ed683871cdd2708dd60d016fd56d35d6d397ce2bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2c1a7300c5071aec4e09bb96189ef715d5856ca26e069c48207a7b5259ac1897"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "6c3ff4de7d69c2154e6e0a38e10e960ddd50ad93b74267e9340ce91a828beeca"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9003f1067aee189008a5d5e79a1dc05311784926d2ee790959fd16e84e36b5db"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4dfb96c3ff6e8cd3e4a75dac84f4128e8d28fe50d04f0730a3316b6cd0f67f7a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d3fda87ed5fd412276c38627a6123c838d7a20e9a2a31c70df33137404a733a9"
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
