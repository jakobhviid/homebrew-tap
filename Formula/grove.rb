class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.4"
  license "MIT"

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.4/grove-x86_64-apple-darwin.tar.gz"
      sha256 "12bbab0371d17b58f1df70a40c97642de8fc62678f0eba87c353f953ba9dfec6"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.4/grove-aarch64-apple-darwin.tar.gz"
      sha256 "70fd3ebe43908f2f7ab1b0f3068e9096335025438ebe9050e7726239f3478e55"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.4/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6266b694af95d6d4650e3d7e8e69fc9b739f722045aa27190747cf9be86aeb61"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.4/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8b167e2c802b414e0fc53bbceed2f45626803ef629723797527b9a08437dc732"
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
