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
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "47d044b38afcee74b0c8d1dc2d99f01b8a12984406e92b557e7815c15ba1bdda"
    sha256 cellar: :any_skip_relocation, tahoe: "d23bd347a990574589472acb343429af034ae3e7f0a8302af8c855356275b14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ddf8b896b0e55dc3a485d07cb7e19c519b19d7c2b040f7bdc2409a9b5116dc3"
  end

  # The plugin loads inside opencode, and `setup` wires it into opencode's
  # config — so opencode must be present. Homebrew installs it first.
  depends_on "opencode"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "e3b3d3f786740735badec7d79cceba715db87dab5eb8d1e04b4c59035ebb0819"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "2cc54939c58d372aa70e85d416930f32b9ae24b0fec8786160b5ca52dc5fe1ac"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "40f94f003f6843cbb49df70885c66973590488d77bc0e5e69f6dc4cc5367f5cc"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v3.2.0/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8071160a71cedb8bae5c2198493ef33c04c99d3ecc8af966834c1204b04269a4"
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
