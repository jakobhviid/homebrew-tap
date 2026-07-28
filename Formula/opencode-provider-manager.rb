class OpencodeProviderManager < Formula
  desc "Install & manage the opencode-provider-manager plugin for opencode"
  homepage "https://github.com/jakobhviid/opencode-provider-manager"
  version "2.7.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no Node/compiler gate): macOS on
  # both arches, plus x86_64 Linux. Anything without a matching bottle falls
  # back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2d60ef08d7752c3c8e4981e441affb5405a76a5a6181b71a13b2e4e70ffa547b"
    sha256 cellar: :any_skip_relocation, tahoe: "d27dcbd8d25a53df350ad02c932869c8b2198b72638a0fdb3438db9ab73db29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8ecd803fa6a00dd007ed3bad4f92f26a8c7e84aacf1f9e9846e61769ab4048c6"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "aef01179fcf1d65e592df19249654ee804bddc2cee5814a814d224c0b8e7b40e"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "c3666894f1f59791ad9e8f3a06283e16259dfcbd858e5d1b4ad16f285f7dea66"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "54ec0ff4c971c48331d14969b436444944fa9f47439b276a7424f0ba25180551"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cf59af13a1a3abfa74e3ca38f528bdf09b1faf916b9f40fca8c305afa3805554"
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
