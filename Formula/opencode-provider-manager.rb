class OpencodeProviderManager < Formula
  desc "Install & manage the opencode-provider-manager plugin for opencode"
  homepage "https://github.com/jakobhviid/opencode-provider-manager"
  version "1.2.12"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no Node/compiler gate): macOS on
  # both arches, plus x86_64 Linux. Anything without a matching bottle falls
  # back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v1.2.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "754d28ab76b2f74e4e12c723500e7298ff67c6b79912b946a10eae0aa8df0fd5"
    sha256 cellar: :any_skip_relocation, tahoe: "c79f2eaa5717142e43be4107f7f52c4163824e3e3fd9599cb4a6ef89c1565763"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cb35bdbeade66788360512d984e6c633a3833497081c45cc4e9c405eea0ecb6a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v1.2.12/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "bf6585012f04d2d2785f3d280b7de19e2835f194817b4d81c44acc00d3e1b0ab"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v1.2.12/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "6fba50535ea4769de5dae6b69bc94c59528c77e4885b225ccdc84d382f3672c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v1.2.12/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6a474ab8a769e373ffbda07acf964dc98223ba33fcdbeafb621dabd5d4dde92b"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v1.2.12/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec56feb18105c64adf61514cb8cc9e7f8efea76d61079307f892636b32938775"
    end
  end

  def install
    bin.install "opencode-provider-manager"
    # The plugin JS package (package.json + dist + prod node_modules). brew owns
    # and upgrades it here; `setup` points opencode at the stable opt/ path.
    libexec.install "plugin"
    generate_completions_from_executable(bin/"opencode-provider-manager", "completions")
    (man1/"opencode-provider-manager.1").write Utils.safe_popen_read(bin/"opencode-provider-manager", "man")
  end

  def caveats
    <<~EOS
      One-time wiring — add the plugin to opencode's config:

        opencode-provider-manager setup

      Then restart opencode. `setup` is idempotent and points opencode at this
      formula's stable path, so `brew upgrade` keeps the plugin current with no
      re-run needed (just restart opencode to pick up a new version).

      Remove it with:

        opencode-provider-manager uninstall
    EOS
  end

  test do
    assert_match "opencode-provider-manager", shell_output("#{bin}/opencode-provider-manager --help")
  end
end
