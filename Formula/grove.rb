class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.5.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.5.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bde29b24cea7eeaab83e9686e7d37d046d615eb3513bb5dd653822bb9c44c6d6"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "c48ddc0abdfec0cc738211c10a0b7f6e6784661bff2b616450b9e55a1fa1063c"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "54a6f1d7cec921210e32c72a6f2b8452853a77abb7409437c5c0a50548d37649"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bcbf5f6800750432a02fee9a29f00889c94007d09cac36290573fa8c9bf2cd8b"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.5.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9495859e0887863d1aa7154a3f124cf7f76c8292b29b4a795f7ad111da589cec"
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
