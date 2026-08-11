class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2b8bbab70703e00c61ac0dac1de8ef4a4620159b52e8cebb9748c211a08db348"
    sha256 cellar: :any_skip_relocation, tahoe: "6a87b51da3612d7930c8d54064932e4a0c3879185ff650fe16cc220c6cfdc776"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6e783c3476d0fb2f66e0858a4c8e62027b61a0626867c9f601b32461102ad796"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "6a6e7dc4959beea0c4e90cf5bd7130cbf65af78ae8b45c6da2d2fdc5d70e871d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1ac9bd17b6ce065fc7ccb9f99a45d41131cbbb3433f470f774d68787460a0f02"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6aa6c766696d8f4310479cc943c1aa775a2ebef6d3e89dfd6bc8443b126e887b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b29f6d57bf5b72c5e59409c2f5fee28305ba58b597dc4d50b52028216e3dbea0"
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
