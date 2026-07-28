class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.8"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e2e7759544a3d13f0c3cdc287c57ccaec1e102e04ad1adda44d948228fc0bf1a"
    sha256 cellar: :any_skip_relocation, tahoe: "15db9b8f45b0ee9fc6c8734c8097a28536ad14deda63f84eb643f82b03e4a0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "066f80d896666c0a558c8da688341903a3473a2a4a8214b89a537cf6cceb50f3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.8/temper-x86_64-apple-darwin.tar.gz"
      sha256 "84b04da68cb993f3158f9e6096e43829d7605c3bff3ab70a66a1479c2673a87d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.8/temper-aarch64-apple-darwin.tar.gz"
      sha256 "a82bc08485c810c675bd0a5f1b67c55539e5c4d0713004aac4101e3942a267d7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.8/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "872b832ef3645c29efb03562b383988a3476a0eca82b050a44e67ee042cb8645"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.8/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6bd6fe55437a76f44d561133c327277f0c4f1df97abdad006963a9f15aa58378"
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
