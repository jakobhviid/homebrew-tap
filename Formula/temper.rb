class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.5.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a24a16abd710085f8bb670930adf12ba7f4ea0671724675699dbea381311a24a"
    sha256 cellar: :any_skip_relocation, tahoe: "fa6a7b022c2a32bf0fd91a40bb9146637bc619297a566c08c1ce964ba2913f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5679e6dd6dc83782b8d7f47bb356d04ff3a511624734b73aa67a2146df6496f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.5.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "0b38124c86e2e6440bb5b8378645352aa922b5865735dfabf52462afe47fb71a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.5.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8096ef0aeaf6090b817bdd6abf0aad4e534210d489f2bdaccf53a869ee2b3b40"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.5.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "207efdf4db4381ae0be50c887fb0e05e6ce7fccfb0be749a4b3c6abebc923827"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.5.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "75244ecedd94b84a850b83f0df5c12d5f572f075391f45934ae1168a7fca41d4"
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
