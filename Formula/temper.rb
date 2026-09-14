class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.9"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ff540d8cc1ebafc9addf8a901756ba3427251a509dbcd28b02713230f498e50d"
    sha256 cellar: :any_skip_relocation, tahoe: "d3b851ef6c509dc40a9818c840741ada53629cc0e7c579ea2156c716447d2516"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de061ca85f9274267cdc8bf882c710a5f147f49d801c983ec3232b00f8aa959f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.9/temper-x86_64-apple-darwin.tar.gz"
      sha256 "de308bc943f2414a0d9514ebdd1a3451a992a94ec19db1cf20d333eac62ee473"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.9/temper-aarch64-apple-darwin.tar.gz"
      sha256 "68c063ab1f32bb4ea0898a1d1553da18a81f160b3ff689d06d7ddd8584c05e01"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.9/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "79208ff5ff7fda46cb4c3dee5237400add8dc27c03865fd5e62b4dce48309058"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.9/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b9cc586af0ffa8fe894e18a763016c372e3be76e343a5d59eafae2f775eabd08"
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
