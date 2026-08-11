class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "daa689c4c364793f1f18942c2e9ee25a8481c7023b998ccf055d242df444f3fc"
    sha256 cellar: :any_skip_relocation, tahoe: "11cbfc3bca4a6a877928f3f1705a1f45be0a278ae2977686ad962b34cc8ca77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f35f32248e499cb0789dff9bdda97d01c086d6d9cf214051d51bee4d7fceeae3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "2b30472531dffd286c3fdafb77237116a2db19e7e1342708805687d6dbddd3d2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "fad4947d17542660011414f72b24a86a3419041bf096e6c945b9e505c86d1837"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6dd796d76593765784a7f42f12dbc87e3a184073ca1c1610498454244126da3e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "34469143033f36a3e54e812ea7b9fd7ca5845771f770c116433f2761848558fd"
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
