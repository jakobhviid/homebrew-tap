class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.4.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.4.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a9745c8df15946c1ba7e2e92bf12fd55a769181ecc4bc441d95240739fe130a3"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.4.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "5523cfdb76f19b97382b965474d4dd6b3c2b761ae07e8077b5773db6c0474059"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.4.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "a6da7042b18068a17cf3cdae6d19065c34c83360cfe55438c2734694fb1922f9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.4.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ced047008b808ab58d438fec1874e453d91caf24b5bd7f5c8c61fabae3d7de5e"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.4.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2290a398cbca0d0cd709cad651328c4b361c1c80a2946e5e3908f11d010ea328"
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
