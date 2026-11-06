class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.9.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.9.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "17a2428ddabb7fa0a09a93a452fcc55421357aed8bf6204b67bfaa9922fdcd75"
    sha256 cellar: :any_skip_relocation, tahoe: "be6701f661b44b2e14cc7b3015b6b888d16e2f3d696c23ffded7c6c0b70aa30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "739d87bb78c495dff12fa5b6515c4d9b795e2973eb8bac7232d9f58b9c5e6455"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.6/temper-x86_64-apple-darwin.tar.gz"
      sha256 "0dc4f9a46449aecb2192897d2f5d507f7a2ddb221454562e8775dca5128a3c10"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.6/temper-aarch64-apple-darwin.tar.gz"
      sha256 "dba4c87979f4a3eef9805c6804666ffb890007a6f3e51c81e8d3cc3ac63bfcfc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.6/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "59b33648b4e0319eba7967e34b13959bd1c967ac760823f87db97da189f49a82"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.6/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cf75c81883a2cea869302b238413803919b22fcaf96040540fc4441d8f128700"
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
