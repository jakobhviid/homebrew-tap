class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.3.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.3.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3e92cfa04305cd8301838c31ae961fad75b3630f780fcb16de387fabbdff4f6"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "3ef295dc51891057ba7ec960a28ed11aa9cb6ad6ba0c1f6d863f131c443a0159"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "dad5adc5612d24a53e6ac56504accf42f5b1de0020aefe79c4dcb8ba8617350e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cd40adda2a1c03f1f7e1d151a3fe4d995aa7c9cbc974d6a28f060e961a2e90c2"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0f11afe26e53075c811b0aada8b224e0a45bc10307f22ffaaa00ac5cd505b438"
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
