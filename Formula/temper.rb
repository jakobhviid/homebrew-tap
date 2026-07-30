class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.0.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.0.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0c24bb2e55e259c889535aedbe4ff6c5014461f19459652b5eb8c98eee7a62ae"
    sha256 cellar: :any_skip_relocation, tahoe: "50583b7dc0e91d7b6683d5df525c3752db71b90469f84ef900144410928dd337"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "31e11ad475e2e092166a12cf0d9293156422381d7b24ef48360920501878868d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "16538e64ae94a3785e8e4d7a3c0c20bb54c847373acddf3d0d5283b2fba09a79"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "65a192db5815a42f13105c2fb224ee9f761b7bb6da0b595badaefe17b8116fbd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7498daa95a2a890ab01888ff05a96f216d17588bc95ae740ce33bf97e43aa3a5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "75477ac57e4239bc989e79bd5ba1bf81302534ab43e501abf10d48d260093843"
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
