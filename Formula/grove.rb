class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "3.0.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v3.0.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "569aba8f0db1b494dc2fd24c9ce642df7115cbd6343b9d2fca92391bca1fead1"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.2/grove-x86_64-apple-darwin.tar.gz"
      sha256 "96bacde7ee2b383aa5c389eea1c41c838f3e2abbedd727c4cfbdf64a81428383"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.2/grove-aarch64-apple-darwin.tar.gz"
      sha256 "71d145a598edee6d42b42d2217022f4334b43af382bd04ec5355aeb2a84def18"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.2/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "02816858b31210a223e26b7560554df5207d3268f6920c92fcb7414a8a056f0c"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.2/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c8184f5aa20ec7a9740286d0808555acb44bd32e4d73d3b37614b3f6fc10ff3b"
    end
  end

  def install
    # grove is a single binary: the git verbs (status/add/commit/pull/push) and
    # the multi-repo/tree tools (overview/sync/push-all/tree) are all subcommands.
    bin.install "grove"
    # `grove completions <shell>` emits the suite's completions. For zsh it's a
    # single `_grove` file covering grove and every alias (they inherit grove's
    # completion); bash/fish cover `grove` itself.
    generate_completions_from_executable(bin/"grove", "completions")
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
  end

  def caveats
    <<~EOS
      grove is one command. Everything works immediately — no setup:
        grove overview / sync / push-all / tree     (dashboard / sync / bulk-push / tree)
        grove status / add / commit / pull / push   (the everyday git verbs)

      For the short names — gs ga gc gcp gp gpp (git verbs) and lg lgp lgpp lt
      (multi-repo tools) — provision your shell once:
        grove setup            # writes ~/.config/grove/aliases + one line in your rc
      then open a new shell. (`grove init <shell>` just prints the lines to eval.)
      Rename any alias that clashes on your system (e.g. gc, or lg vs lazygit).

      Run `grove` for an overview, or `grove --llm` for a machine-readable guide.
      `grove tree` and `grove overview`'s clickable repo links use Nerd Font icons —
      use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
