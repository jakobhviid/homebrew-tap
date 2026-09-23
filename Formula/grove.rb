class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "5.0.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v5.0.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb16065948feeb95209131f98e8b39476f98d63fbcd53e0448954892c90a0b66"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "954c9c412060494021facbbd2e8688a56941c3b49be3dd9a64314cb174b52151"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "07b8cf2b501d7169beaa7d979e94c1b02df45a6bd992acc5961c5fd45fed7ce6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5b616a063d8a9876c6672358972599a478d4a470835531792c0a37e15e7f2719"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5c2a2a21742e77998ce9e685d633e9c0e1b3aeb14a47ed592ff75b948f0ced35"
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
