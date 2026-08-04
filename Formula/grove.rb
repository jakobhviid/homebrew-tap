class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "4.0.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v4.0.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f63a708f302a970127a9e2fb3bf8aa6f4bbe10843d34922475478d56b542b01"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.0.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "f8d653799f59fddcdbed0e67c7a79b2aa8e8c299fee7c7fb5dcc7a881f6a5787"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.0.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "c6ee1e5803f687caa64dc46b033b215de1d18057b4dbfc62586930ea6f4049e8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v4.0.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "48e10c3baa6d138bef597c4bd072d11f45212ceff1c9c3beab560a16ae82e46a"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v4.0.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "458acba9ed1e3ce76543df5033ebe811a9e3456d26cc670acc2bfea53d3d8972"
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
