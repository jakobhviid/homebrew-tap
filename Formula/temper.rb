class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.11"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ed308228780d4871ff9f95158b0002394ff695337353fc721196e4c48f1c1515"
    sha256 cellar: :any_skip_relocation, tahoe: "a4ad87b9645360120876362149ba91d55aa8ff6c53237626634374948e3cbea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b5189dd2f5cc1faff7d50463606387ede1a54546b67f73d3bff3ab9acce92b1"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.11/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3c29df6a128c90831c4e9a19339d629f6651adaf50e71211b97125f874346627"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.11/temper-aarch64-apple-darwin.tar.gz"
      sha256 "eebaf1829bb9f60eafc84e9ee1460e1b45705ad9493f80409011251694973286"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.11/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "16beea5e1973c4536556f5817ae3de1dc7ed89a0f6aad09401548d89695779c7"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.11/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0152bb8f7641ef3726c8686b911e584d96d040d59fcabce5425d96f11dff6d38"
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
