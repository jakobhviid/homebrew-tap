class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.5.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.5.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98dd9a43873107667ea09123b070c8855539af30534612ea088d56a84f503ed5"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "2c9cb8514f5d78ed262b242a1b5b5087b1a91cca047cf4062cbbe71bdad04d33"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "a8dbe8c722c8c69f085214e37319e8499a7aad199cbb3c95eaabd1876ab445b8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e58ce6965eb778ff2c456712362ccabc83bd0da8a3946166a4204985b4013056"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "afab4530a6543d2ecb88f7c8849b5ddf1d90640bff841c6891c62cec946ffd9a"
    end
  end

  def install
    # grove is a single binary: the git verbs (status/add/commit/pull/push) and
    # the multi-repo/tree tools (overview/sync/pull-all/push-all/tree) are all subcommands.
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
        grove overview / sync / pull-all / push-all / tree   (dashboard / sync / bulk pull / bulk push / tree)
        grove status / add / commit / pull / push            (the everyday git verbs)

      For the short names — gs ga gc gcp gp gpp (git verbs) and lg lgs lgp lgpp lt
      (multi-repo tools) — provision your shell once:
        grove setup            # writes ~/.config/grove/aliases + one line in your rc
      then open a new shell. (`grove init <shell>` just prints the lines to eval.)
      Rename any alias that clashes on your system (e.g. gc, or lg vs lazygit).
      Tune behavior with `grove configure` (cache, default_dir).

      Run `grove` for an overview, or `grove --llm` for a machine-readable guide.
      `grove tree` and `grove overview`'s forge icons use Nerd Font glyphs —
      use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
