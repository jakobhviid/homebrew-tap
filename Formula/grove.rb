class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "5.0.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v5.0.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "647c16081f0f340aeb64a3d3ccc34fa9e3c0288e6d953b443f13ce2e4b6c21a6"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.2/grove-x86_64-apple-darwin.tar.gz"
      sha256 "f110b6f3f9bc5c46e3dc382b0667e990f3fe697e45d6733b1608d3fe144143b8"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.2/grove-aarch64-apple-darwin.tar.gz"
      sha256 "c1bc0f8ab96b8db5b32d71d9c9b7eb777967c231967c0df6f3898aea84734e57"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.2/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aa122dc705abc0d8f17b7de3d64d28a97628e62692d28efb1bb234c858aa3f9d"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.2/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c86545f9c6cb054136d3db712cc3e127d40ca01467d6fdea9c5f8853f06e1532"
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
