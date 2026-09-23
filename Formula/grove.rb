class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "5.0.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v5.0.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c57db8d0205a9239449e778d57b5d8c14c7a8fb1008d2c21eeb1c65b746c0da9"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "440eccfe3ec967f43106e3562e83381c6948c70d3df3f60f30bdccac65e1a549"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "bbde49147d5307659f5d0bfd2f200f984ed8b57ef44ed445e2e4c0c1faebeee0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7e4b42739472cf2f28df7618b76112f8fa4e267c1e0cc33c80fe6a4350b47b55"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v5.0.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4690c0a7b32c11b05860fcf478854eed3985e958b6290d7ac28daec5e4f35d52"
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
