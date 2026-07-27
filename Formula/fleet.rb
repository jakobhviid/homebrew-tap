class Fleet < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/fleet"
  version "1.7.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/fleet/releases/download/v1.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "56087f777fed6012627975dec2929a2a8ba914eb994ba0e59283e5d560640d84"
    sha256 cellar: :any_skip_relocation, tahoe: "968d71c652dd1420983f6b484eda8dbe511b73319ac97167e47f7e89594dd31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5d0035f7237e9d450d4e2ff184b8a5b019c4e8a4132edab7c13752671bc9f3d7"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/fleet/releases/download/v1.7.1/fleet-x86_64-apple-darwin.tar.gz"
      sha256 "32bc5dede1c30f8806cbc8e0d59a1692b30941196f498a00f22ac64b65423cb4"
    end
    on_arm do
      url "https://github.com/jakobhviid/fleet/releases/download/v1.7.1/fleet-aarch64-apple-darwin.tar.gz"
      sha256 "2aa1e05abe30250ed63bbf81458055d729a85970f065719aa40252c60a69977d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/fleet/releases/download/v1.7.1/fleet-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fdcf878e1101df1d951b58462b5639379fdbacf758a7638ed33df228cf98e275"
    end
    on_arm do
      url "https://github.com/jakobhviid/fleet/releases/download/v1.7.1/fleet-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3435cf074310d3ded21918db02bf06eea850753f490436b4140da63ed13e3845"
    end
  end

  def install
    bin.install "fleet"
    generate_completions_from_executable(bin/"fleet", "completions")
    (man1/"fleet.1").write Utils.safe_popen_read(bin/"fleet", "man")
  end

  test do
    assert_match "fleet", shell_output("#{bin}/fleet --help")
  end
end
