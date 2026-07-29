class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.40.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.40.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "107e30f36fa6c292f334fb18a023770d665471128005a0a32399e283575b8e43"
    sha256 cellar: :any_skip_relocation, tahoe: "6a144e88cd9eb4eb8eb6911d5fed3f00f3316c03d1d93a89760f4384af199ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c211ddf21d863a373f9abae23021622075d58d86bbb54711bd371223fe2d568f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.40.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c63117193151cb3f91f43cdd8e847860fb43927e839f2a4a967558acc65667e2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.40.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "dd95baf9aea572a91281be6d814728ff2d822f8884dbb679466c31fdd26302bb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.40.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fe9f79329bd845149a4b983b223352745c92cc68d9c74bcc6be3bbd35eac69d0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.40.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f9b62f63547f8d65f1e48061930ebe849c9c9d5a6830626687a271fbe89464b0"
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
