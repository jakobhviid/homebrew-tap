class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.6"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6d2b12fcd109eade04b517841e9bdf0cf8deb025504b6d692e28901acac13aff"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.6/grove-x86_64-apple-darwin.tar.gz"
      sha256 "3cd57f24482e258bca02a9c90af70cb95b6759c8e91d2afad6342755ffe18477"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.6/grove-aarch64-apple-darwin.tar.gz"
      sha256 "d0afcf9f80b6110ce410b845fda6a85d6b5025884e7e13c121f72036a049da1a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.6/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "169a51f3b23916624ceddb82e97f3c03b46237aa4a4fd11858ebc23934897ad2"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.6/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5a5d4d994b4b490ba3959df4bd694f23746ae055d39bbf4d49eb5b02bb11712f"
    end
  end

  def install
    # Each command is its own binary — no setup, works in any shell.
    bin.install %w[grove gst ga gc gp gpp lg lgp lt]
    generate_completions_from_executable(bin/"grove", "completions")
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
  end

  def caveats
    <<~EOS
      The commands work immediately in any shell — no setup:
        gst ga gc gp gpp   (git status / add / commit / pull / push)
        lg lgp lt          (multi-repo overview / sync / tree)
      Run `grove` for an overview.

      Optional short aliases (gs, gcp, …) via a grove file:
        grove example > ~/.config/grove/aliases     # then edit to taste
        eval "$(grove init zsh)"                     # zsh (or bash / fish)

      The `lt` tree view uses Nerd Font icons — use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
