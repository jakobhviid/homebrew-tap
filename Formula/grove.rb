class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.10"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a2222e3aaf64bb6a05a98fef1bdd56c818cb027654514b1cabbf3cd45e1c59c3"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.10/grove-x86_64-apple-darwin.tar.gz"
      sha256 "c7393db2528e35d45f41aaad7e544823a1a1c3894e322673e9b5e2bbd869880a"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.10/grove-aarch64-apple-darwin.tar.gz"
      sha256 "7744667d90641ac247b1cda8e25653d6269794ca00d0e50eeb666785e8ab617a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.10/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ed4d665fe05bf5d39d5279f02b7f12a209236f10058684ae1d9b7b27e72e7148"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.10/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3ae9ad5a54e4bbd926d804fbb3299ecef05e4347dc130157d087ac967c0e4af2"
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
