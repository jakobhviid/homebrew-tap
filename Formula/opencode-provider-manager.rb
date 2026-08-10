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
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ee69cd71aa115ac3e6cbbbca5596dcebc3b57306a1f3d45c8a825f459f04a824"
    sha256 cellar: :any_skip_relocation, tahoe: "0e6ec6fe009436bf858b7e6f0f4c690111171e94cf4e0af0bf697ec5e358baae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98eb311bc1bb7ef53ea4f93fc8fce7812b78141487be62f5582022bb83438ec9"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "f6ad8bbba9bcee6d388956bd549ec3a51310fe7dcef2c01517be158f07061c85"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "602940ab79468adeeda4fc54586885313bc5797cdf05f51fb7ac423eab0736fa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ad09ae9d943e720bd3dc2e3c4e0f4901f36130ad4d4e7f1bb1e7be7baaca6237"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.1/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "db281f966b13bedcf59bf8d08ed69991bb527beb4078c3cbba1d0591d6fa0425"
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
