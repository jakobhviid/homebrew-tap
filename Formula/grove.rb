class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "5.4.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v5.4.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60b38aa87138b6ad3cc65e062863117b65ccb51972e4a995a099f2710314913e"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.4.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "85872c3b150bba69fd650cc0b11f42cf2745f647c2bafa9b6474b16bf0c56e76"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.4.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "0eca9a0087e35b75ad6a5c86db5c7148d9a2c73d95610a1c2e6d142c898e0e5e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.4.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f8b6d3e19c4f4843f992c20bbd1cb7ae6fb29a52eae41fc5a1dd74e4968c37e8"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.4.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d7f70d2c3f87cc77e09086973b98c20fa03476498894832853c9697ebce9ba27"
    end
  end

  def install
    # grove is a single binary: the git verbs (status/add/commit/pull/push) and
    # the multi-repo/tree tools (overview/sync/pull-all/push-all/tree) are all subcommands.
    bin.install "grove"
    # `grove completions <shell>` emits the suite's completions: one hand-written
    # file per shell (zsh, bash, fish) covering grove and every subcommand. The
    # aliases complete through it — zsh and fish natively, bash via `grove init`.
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
      Tune behavior with `grove configure` (cache, default_dir, depth).

      Run `grove` for an overview, or `grove --llm` for a machine-readable guide.
      `grove tree` and `grove overview`'s forge icons use Nerd Font glyphs —
      use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
