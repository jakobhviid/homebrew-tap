class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.8"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "101abba0ea5db0f3d4974196a9856afbc3ebdc4f17b26e2d71e6a8375403f0dd"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.8/grove-x86_64-apple-darwin.tar.gz"
      sha256 "e03673cc1b46e953055a53b68676b7373c1737459259619bf63fa064f22c2d05"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.8/grove-aarch64-apple-darwin.tar.gz"
      sha256 "77e60f8a190480650b421a3dbf20b0f134d9474ae71e1a6366116eae4fa4ab77"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.8/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8d7c7e84ba0cb1e15a0d0b97e4bc03ebab1b0636afb4588d3a05dcfac25cad26"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.8/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c9f18fd56982e86f9bd015f57ca07517bc91b6071d43ed24c2c099b3c025ce46"
    end
  end

  def install
    # Each command is its own binary — no setup, works in any shell.
    bin.install %w[grove gst ga gc gp gpp lg lgp lgpp lt]
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
