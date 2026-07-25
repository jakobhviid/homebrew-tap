class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "1.1.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v1.1.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f6ec1d05659f0f210b2cae2b9a4c593d0cd302ac2ca21e616d5bd53412fe66d8"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "c3d4ef9ee9d08207b558774f9e8d4197d5990409b5cd9ae737c017a00060bca0"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "53a7afdbb9e83d3f5be81ca3bc09079c8332d7cfa381480b89244dd3457522ea"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cf3847bc10e165cf7b679da070277a72dd2f48a6f7c8118913655ffdd8e6e433"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e0ca7e8e81d3ee0084d3e5f24829108e590fa52aa04ad6a2baaa1b417be56413"
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
