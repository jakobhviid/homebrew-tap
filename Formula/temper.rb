class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.10.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0fd3f600a4691ccb9c5f1c566d237eaa328999dfcde19c339d04fa91ed50b63f"
    sha256 cellar: :any_skip_relocation, tahoe: "28195b153c04b0444309007b114381c25b4e73154b47216ec07ba3f41fd802e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "11ef0aa5a4a117489e3c027b8e7fc0c8e8b5ee472c91d3ca37f025a828e1278c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3033f2ce79e40093e436a759ab888cd2cd66c8941686159b6e72dcf44d39a452"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "885791cd4dcda83dae716fb3b4b394490948475b5e935567244ac44fc767ae67"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f21f7c8d4aa01ea3199b8450d4f9228418a9136f820277ebf0370a652c47d04d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.10.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5b7e7b1b08d564d0de1feb15f5eddc808c3851d221e90edfe5b608a6bbc92b3b"
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
