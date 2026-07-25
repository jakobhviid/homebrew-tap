class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "1.0.13"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v1.0.13"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03713c0a59335f010d17cff10043dbe98c84c85509a5bbc84c4516e1c3f1799a"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.13/grove-x86_64-apple-darwin.tar.gz"
      sha256 "80297d1145708db9850cd38399ca4d5a211b1f9c2c16c984a3510ab9d80c4748"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.13/grove-aarch64-apple-darwin.tar.gz"
      sha256 "3f6a4b573af3514ebf626027aade9f92fc17abdd77edeb68a6d12d93360a9efb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.13/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ae93cced346e8f8cf4e7b015536157069e718792084c67d0f5d491e4eaa59150"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.13/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a11b30decbe989ac19ab3ca1072a575a0f8d46f2fce4824527d7f9bfae42c87a"
    end
  end

  def install
    # Each command is its own binary — no setup, works in any shell.
    bin.install %w[grove gst ga gc gp gpp lg lgp lgpp lt]
    generate_completions_from_executable(bin/"grove", "completions")
    # Man page for each command: grove has a `man` subcommand; the rest render
    # theirs with a hidden `--man` flag.
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
    %w[gst ga gc gp gpp lg lgp lgpp lt].each do |c|
      (man1/"#{c}.1").write Utils.safe_popen_read(bin/c, "--man")
    end
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
