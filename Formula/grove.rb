class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "1.0.14"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v1.0.14"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "04b45323f5b1c9070d4a4b8cbbf73f10e8ed5d484b8a8913929bdbf9df6622bb"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.14/grove-x86_64-apple-darwin.tar.gz"
      sha256 "49dcfd91220c179c99e6584d4e746ab72a6b3fd525ed8e5cf01502d5dcedc8ef"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.14/grove-aarch64-apple-darwin.tar.gz"
      sha256 "c5df1815a6b1a7af2d300fbe1bb100f3f6f9d386549449b922c85154a7217d03"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.14/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9940914bc44225b5b4ab1587b388a4e2562340a68383a9de86caf086e6f1c2eb"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.0.14/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e5d20f7c1ee354e6867220e32a72ac66c69d58f241d88f77a1e76b629f290707"
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
