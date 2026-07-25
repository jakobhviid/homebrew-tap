class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.12"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7ce3e41c5c5b51c3318c598defa8561c1db570d26c9cd18ca499957d10017a6c"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.12/grove-x86_64-apple-darwin.tar.gz"
      sha256 "0bef52d81a1eecc235894fa4dec57f2467629117e773889de5f83a04e0f5ef57"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.12/grove-aarch64-apple-darwin.tar.gz"
      sha256 "238c5ba997fe1ca7d7c03be0f52c349be80bdf6570036740c5827d95a300ab55"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.12/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "800d721b04b3c0efe2946ab41ce3e27073ac1a7d0562aaf39b03a635bf7114bf"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.12/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7f4a82493a0b710267ed766dadb183ab6f05590b0c33f48a32d8abba19e6cf58"
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
