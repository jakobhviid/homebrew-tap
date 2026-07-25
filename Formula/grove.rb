class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "1.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v1.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f11eb5d49b0e98e79308aca5976b566503f2bc4d004ddd843c64fdc0379eccd4"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "52063ed2f43be899ddbb1dc7d88c222110915cc42fb06cfa2812d3ef53d28b0d"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "00452a5a10d46a6b12c3425e04d07e3e9003474776a0f07d624d09414dc6ddb2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f172503c07b6729e2194514899cca2c93c17cbe2b0c1896b8cf588750f98a8d8"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v1.1.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8987abd74e11cd37b7b6905f62b68e81e20874e0c258611a65f255075b8bddab"
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
