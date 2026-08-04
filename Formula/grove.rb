class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ad4e2b704d3e4877ffbaa694b0434f52864f9670782e20e06b4f988e407aea6d"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.1.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "d33c3ce2899a027e86ebe5647db0b245961c58f47cb7ede91f3b06bbfc8ae2b3"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.1.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "8558bf98adf04187415a2dbdfd76e94c77949e3e2c0996445ff34f5b61f9a1bd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.1.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "69adedaf264d5b0faf75fb7230faebeaf92a3f8fdc75d5cb8d183565ba8b0e1f"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.1.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7b051665b23b9215c408484d9293a4fd898966cfa07b7ad22ab3813abfe99e94"
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
