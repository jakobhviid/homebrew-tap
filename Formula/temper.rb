class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.24.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.24.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f0cb86ca85aaec0a4df6b2b3cbbd9eca56cb59c9bcc8f5b518c424bf17840eb2"
    sha256 cellar: :any_skip_relocation, tahoe: "3f4159dcd2f779dd2f73a939eaeca383f668220e15c7a1a91b441fdbc091b7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d14e3e9ade1d741e1d8b2e8fa1bc6e0ef39ac1246195017149d967dd6a77d4aa"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "8e87b9d118529e3ba91e009f9173ad183e5164752e1f0199a989a46d21b1fc08"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "4117422f0a02d27f81b94f8052626c771be7eba4421de8602beb7242d1cb83d7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ac845aec0f17cda7f3c9bb1efe83e9b55a970c95b4c1456b3fe0988fc4ec0afb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2fed5bb3a4c387d8291008e4fb4dc17afc955b9ec6225880b92403d1ec29c742"
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
