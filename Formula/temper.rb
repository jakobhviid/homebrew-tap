class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d70abc7eca65cc2b7c827a20ec54391c63b28e559e84d279aa9bb472579a273c"
    sha256 cellar: :any_skip_relocation, tahoe: "4210ae6f6551ca025acc18b60db8421f8a72594dc2a2699647b3d90f5d3738fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d2067e458ad1fc9c832c187559c703b808ac46ae63ecb5cef2bd9553c16390fb"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.6/temper-x86_64-apple-darwin.tar.gz"
      sha256 "4b9bb640c9b7b9e8d019a0cfb10b15f37aa7d2ee9c5181f1b0b0cdeb23072541"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.6/temper-aarch64-apple-darwin.tar.gz"
      sha256 "02aed270740b8a7269481f9235b230dd3f58bd25cb244d889683bab9871ace74"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.6/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "96ff098c33db3df3e74276cc16988047005cf2da072adc133fe51f4963fa1642"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.6/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "962418a327903354f6f55dbc4fcf9e47bf01b40a374fa99f907e0761646d9afa"
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
