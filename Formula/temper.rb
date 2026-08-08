class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.2.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d8168a3e4058122698376405ea748b8c08f929dd11e3578a82240afbf0aff4d1"
    sha256 cellar: :any_skip_relocation, tahoe: "83fae419ff781c1b163e94c2f3c1cefdf3d80cf98e5fa6acc5e3c916978650bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d324a69a1c926be3aad49d971538c5a4af8770c174163d0987b542ad1782ee54"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "276fb1bd5a73a75dc986c877a32079342db96b8c8aaf88be0d800412c9a46877"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "db025431d36465ee756fc9fd196214f06852919a93d23d4237a0f2dd0cc59c28"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3dfede4468bff8f600673a7a2840f4056cb907455688de3bd870078e1ff6f17a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1cf8f6abd7884db0a9e733a7628be3079e3329a3ee30878d18d3927ceb07411d"
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
