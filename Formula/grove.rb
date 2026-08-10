class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.3.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.3.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e7dbc9b2d64d55d01b509376a8acc2e1c3954bf6f57a59215341a02eea7e62cc"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "758678b0c70d44e84b0c66aa239f5a071a1e4017d4d1142f2e36e0aa3ac295f3"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "5d6605bf6fa3716bf59b5ae8eea225b10db4a29b61944be8a44e0c666e452182"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fc622977cc03c80a5a594884f100c17f9fca29392b2ab1323758b26633738a6c"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.3.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "65be4a99b5a18ccc9d72e75b6ac32fddf8ae239ce3460ccf19d1c82eec71846c"
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
