class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.2.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.2.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4966a8ceb38f536d402c0506aa6d7c9dffc84bcaacb538cf793bd8f2b5322ae8"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "ece3278cfd36e01d7562c2eff1429492e1b84b7d66c5bc1386ad7bc4c964e22e"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "06b8b8856648d5b83223ea697e57fff8c92575e9302d07a1e0bef22b5704ef7c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aa5a2388e45baad3b2976b9e683d1085d820525c474b91ad3387e90d4fd27d4e"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "55ec9816ef68d7354cff017a9a013df2ca57c52de049e49c6db0a2bc5c4d7ed9"
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
