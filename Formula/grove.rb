class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.9"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b2c532ba51e53c83e280602d08b92954950aa39b95d9ddad399e3758b26ae854"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.9/grove-x86_64-apple-darwin.tar.gz"
      sha256 "e6c895b27306d270ce9df65fb0a6b3c0b200796073ca4ab7c9517ffff41c5953"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.9/grove-aarch64-apple-darwin.tar.gz"
      sha256 "70bbc815b9490c40036fc4cd1dd293238b43df0102a98e22213c99d6189f28bb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.9/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "67ffd79141118d888f79d8bdba50215bb71771cd84642bdfccf2df70d3f982ad"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.9/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9f579b150cd1c67621487262494bde7c3d1313b8fa87ae272af952a3d5f65adb"
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
