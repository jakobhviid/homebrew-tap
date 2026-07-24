class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.3"
  license "MIT"

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.3/grove-x86_64-apple-darwin.tar.gz"
      sha256 "211f0fdeb8885a4de0bec4e0b398ad899d33d2077434171213e5c420283c46ef"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.3/grove-aarch64-apple-darwin.tar.gz"
      sha256 "cc18b8c0d0655c500c7cfda7852d3f7c42c8e7232ac23ab1b726da074f4bf3ae"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.3/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4db8ac18aeb5def04fbcd07df4394ec348f6a1923fb591f8146c194f6bd64305"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.3/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b45495654ae9c8026ead1d3f1a6a3c998e5afe066f9f43002b344d6b22f5b78e"
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
