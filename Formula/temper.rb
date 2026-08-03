class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.0.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.0.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4f81dc7869f0c8e261f5a3a0d82e3a6d3d5e52e985bc7e0f3dead21c2ded7352"
    sha256 cellar: :any_skip_relocation, tahoe: "55144cb8408746ffc6e7a3327181001224a7d288fee57f8b79355d447182cfc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "14864a8bdfab5c53131fb8dd69fed99609b9719e6c2c78d628d69327c13d21a5"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "6a15e18a30975f4919d2dab5e8f0abd7d09f845e86d2003f7d76cc523222cd63"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ab9788cdb38da1219b8f08f2fad4f7dd833b0350688ae335e1f80bec3cfe6ef0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e166b045ca2204dcbfeddf37c6cb2df9c6640b55eb2b8a65c7472526e2cd4b01"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "58ec5579712ba5fb5896db934fb5223eb59582e78ea8e7a96331dad3efcb18be"
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
