class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.7"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b8fa8f527664f9d23a2874c528416a186c347fdd07fffa544ba3d8acc31b78a"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.7/grove-x86_64-apple-darwin.tar.gz"
      sha256 "42807eda4423198b61454fb26854e631f4deaf413253e0f02038f7ae50f2cfb7"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.7/grove-aarch64-apple-darwin.tar.gz"
      sha256 "0bd0bbfb5908007a090c35e2c436e6be74bc0693312ec0eee53320436ebeeaad"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.7/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e3b50ee0f5828602eae94a548ce08ce60a5f115fd584ea3a92a0a0cf738324a9"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.7/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "103a5c78d98f840a2df3c6b0858390def0f08a814b000d7f0709e61cd797ed39"
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
