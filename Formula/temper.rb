class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b4e53b437436fba7253505b97d5b3f499524c5351858e770e301015f54f22092"
    sha256 cellar: :any_skip_relocation, tahoe: "2d91b0170e7169556fe5497be0651eda875ac7233ee0d2bfc001508ccd85f05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a6f84e28d5906d66669a921bae2da21dc5097d7fc74e1de5de3f5a5c0636951a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "f901cff7b58a60eaca5864a49c65ed860dd0dba6a902fba8fef55bee81ec163c"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ccb2a15831abaf27881cae98edf78fd803af4e82e70c92ca50d54c6c99363272"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "66ce63cc1c80b736931286f509e2a5248fa6b5ddaddbe65282fef5f89a51f1e2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a0e19af4b1349506055ae3a44d780c893346853826c00f83cecafd0b0bf23464"
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
