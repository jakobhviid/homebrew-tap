class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.31.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.31.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "72f6794783419c86a23a13d9f0c22e96e67a6674dc0bfb76a03fb5dfe81c7cc8"
    sha256 cellar: :any_skip_relocation, tahoe: "40d7a78f4212844ac6c433d38befd34c9ff594f4e0566f8efaf458bb4fa1aca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "886d81f49d1d68ebcc768b062a2bb07528b555670a8cac909d9b262ff5bb3b91"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "2c9374969f268c5a33d841bfef811c7d8b2a540e449c563034b8dea15b1d1135"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9296ec4ba0863b4a6c95d0485f987233de0a4f9fbbf6cfa317e3a2e5ee8cdbbc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0c5c501040597451fdc26bce80ac23fc1d45ba66f980ae74d62a559f05590c05"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1e1a3cc3e9ac3df1ee19b3a2d2abaa58e7211092df99616e84c9ae7e2d690adc"
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
