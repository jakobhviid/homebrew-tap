class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.18.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.18.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "19719260df425b0067d58d03206eb456b02b41398966c124afc30b07802679bf"
    sha256 cellar: :any_skip_relocation, tahoe: "a284b8b6b5c86c9b3ebeeee4e98df45cb31fe827384f701e4ee089dc598543e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6c5f43448b8c3309d5a261ddbff0422fbcd15853cb4450a4a205f577b2e00355"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.18.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "ea5c2a0b14cb02b34b0510ef8776efd44066b679a2383f45257b2ab895359df2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.18.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "deb4f950e157a7e8618842b7a1098e43e10c1c54ee0ed4e5bc8b3551dda4c774"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.18.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ee3074e364a255039df2062607ef33157380f4f833877a708b92c7b0fe8b0cef"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.18.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "83bd827b27d5174586055f558726b371161b17574c1e3af396d5eef05fbe35a3"
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
