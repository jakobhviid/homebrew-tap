class OpencodeProviderManager < Formula
  desc "Install & manage the opencode-provider-manager plugin for opencode"
  homepage "https://github.com/jakobhviid/opencode-provider-manager"
  version "3.2.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no Node/compiler gate): macOS on
  # both arches, plus x86_64 Linux. Anything without a matching bottle falls
  # back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a70d098fd4b643e6d7a9520f2af97a418f47a6527fea0e8fbacd2b82e2a08f26"
    sha256 cellar: :any_skip_relocation, tahoe: "b83501f0f21fecaf3593468f550e58dc0985f6572d1f2601375428d0a241457d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "330b6c5c19fd85256289b613f6cd9b33caefe008e914432c6d9b1c7d9d2c70fe"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "3f9bdd37f6aebec6698edb46f557ad2c1063db936940504b58df625d5e13a8ad"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "11a03a4327146eded4e51d38c5d18c5655e5f1e3e8721f18b9086a72bb493b14"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f2206c613cf87bfd67f775f1ee1312bb5abc55502189e44b0575635accbef5a6"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c2646461e715d92eb06b93caf22f58440893403ab8f9811a307c9c62187e4c4f"
    end
  end

  def install
    bin.install "opencode-provider-manager"
    # The plugin JS package (package.json + server.js/tui.js + dist + prod
    # node_modules). brew owns and upgrades it here; `setup` points opencode at
    # the stable opt/ path.
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
