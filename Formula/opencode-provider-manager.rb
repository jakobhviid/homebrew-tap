class OpencodeProviderManager < Formula
  desc "Install & manage the opencode-provider-manager plugin for opencode"
  homepage "https://github.com/jakobhviid/opencode-provider-manager"
  version "3.0.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no Node/compiler gate): macOS on
  # both arches, plus x86_64 Linux. Anything without a matching bottle falls
  # back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "24e1e7127927f329acd1a53cee86d81290ac12fd50c7b7494c8b9b2b2666371a"
    sha256 cellar: :any_skip_relocation, tahoe: "1006fafa1466850438b8dc77bab83426062518ccf33fea61653425a2c8ab4a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "25cde2ef0759f05d0fb846079364ed6c78e4ad3d0b59dd70937c43d6a1c4ba5e"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.0.0/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "b63226e218cad249ea7a44eb6e2f7fbe3400bd363f505a41cfad95fcb917cbd0"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.0.0/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "e122183785325fc460143ac62a1fab56523963339ad28038888f560b6d65997d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.0.0/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3dae4817b2ab573162c8a107944ffe2ddbe45fc545b7b34f5899b455d089b0d7"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.0.0/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d048059ad2b757414df5668cbbbf409c86355d1309fa0fc8c1a864c71b422d6b"
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
