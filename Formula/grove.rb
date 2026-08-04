class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.2.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.2.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "916ec7d97ac73d702a9d500e0db213a4a3aa11a725f31729a5cfa5aac0fa9bb4"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "d450fa59157701b3bf7969cfb79bc964435473ca656662d8d7fae4058273e94b"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "fd62685c95388cdba8cdc22df7dbb460027366e0ddb3f8c35b91493c7ff1f8a4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e9f9252fa764b43f966d3a516cc4caaac7f49332dced94fb6d17829074503c0b"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.2.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b37bf1a0e0bc5ea2fbb590bebb45154e76654fb92ae61438238d5fff1530a5db"
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
