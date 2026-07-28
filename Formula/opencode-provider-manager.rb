class OpencodeProviderManager < Formula
  desc "Install & manage the opencode-provider-manager plugin for opencode"
  homepage "https://github.com/jakobhviid/opencode-provider-manager"
  version "2.7.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no Node/compiler gate): macOS on
  # both arches, plus x86_64 Linux. Anything without a matching bottle falls
  # back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3430401a71097947b293a49449586caa2b89b0bf99730fa8c80b78ce65d13f4c"
    sha256 cellar: :any_skip_relocation, tahoe: "92d5c38359d8f51f87d93bf1e5dc4016e10452de756856edaab7418dba42b816"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fec017685167ccff86d2b9fe2d553a0ebcdcb6812c2f7b00c2d6b4ac8c571fda"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "30a39ec9187202cd9721aeadeef072761aac965fd6908230225ce7424222f0e3"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "24000d6c0fd2a9f44f217cad26b5cd25177dc5605dcbf86833b2d0e50d4d0488"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "409f0930e3617b3213c2e14e86b9b0d5ba15c8396a8354679bb35008ccc50740"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f99477b28559ccd7fc0bf048795b043a088aa78b741cd8044fbc3059b54fdd07"
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
