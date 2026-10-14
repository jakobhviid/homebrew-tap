class OpencodeProviderManager < Formula
  desc "Install & manage the opencode-provider-manager plugin for opencode"
  homepage "https://github.com/jakobhviid/opencode-provider-manager"
  version "3.1.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no Node/compiler gate): macOS on
  # both arches, plus x86_64 Linux. Anything without a matching bottle falls
  # back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0f20dcf21f6402c945002b4192a7d1501510b0004c7335cc8d7160f287af1de1"
    sha256 cellar: :any_skip_relocation, tahoe: "21f063407ff1b5766ec896d466364d64abd6268c1d4731e5ccaf52b728690970"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c3ca198dcd317e0122a6fc110ed1b324ea6ba60d94009415677ab6c63e502545"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.1.0/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "fd0c68183cf37ad1a3574cabafd34b0793234dd7135ab8dae5648155c7002a13"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.1.0/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "1da5b83540242a21f066810168d8502c3de4780f94423ffd1a05bccc5b79e9cb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.1.0/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "46346ceca536ff3cce294393024620edfe40633828739644eeda9fba4f714a59"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.1.0/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "55c8cb67948a2dd72647c7e8962168a027b8620048809a14d3fa578134b67d0e"
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
