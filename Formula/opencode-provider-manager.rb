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
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2bebbcfd93158ad9393906823aacecea4bb2851f89cef4533c177dd15650e750"
    sha256 cellar: :any_skip_relocation, tahoe: "928c57318a9710c046142c0314449a1dd418113fcacc2559bf0c0e3532c62044"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abdf58df21b016eca7b446c31ca2478e1aea3b04053027b72711b32e9664edff"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-x86_64-apple-darwin.tar.gz"
      sha256 "8fdd598c81400425816dc18169e982f5e4cced3ce8a067c6c98990c5132d1f40"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-aarch64-apple-darwin.tar.gz"
      sha256 "73854c1e134001cd88ee57223c19316797d3011048d5203dd5eb0ace2fa069d7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a1f1c2193e9b5882e8fa93518a9f871355fa4175f47f97943ab78527bbfded03"
    end
    on_arm do
      url "https://github.com/jakobhviid/opencode-provider-manager/releases/download/v2.7.0/opencode-provider-manager-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a24434bc2eaa17aacbf1e66661b2c151a9734277870a05d38065a63ee2a97d3a"
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
