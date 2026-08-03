class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "3.0.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v3.0.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8009d67f450c920edf386a2ba5b6f61966081e5f9a49ad5e5d33f841e1cb08b3"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "b6569f2bbf9e0c4f3e8829b4503bb675c92d89d4d0a411ff1c0b6ff26ef7cac6"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "dcac65e53782c8008925b922ab65d1db1def0576a2bdb503178b7525dbcb4e79"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c4d62936ed231d7e72cd0a2ed863f3e7099f8e082874fb40dbdef0d7ed92084e"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v3.0.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "046efc27f591294023d760a82b43fa9234725a2798644b734f312efc0c80789c"
    end
  end

  def install
    # grove is a single binary: the git verbs (status/add/commit/pull/push) and
    # the multi-repo/tree tools (overview/sync/push-all/tree) are all subcommands.
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
        grove overview / sync / push-all / tree     (dashboard / sync / bulk-push / tree)
        grove status / add / commit / pull / push   (the everyday git verbs)

      For the short names — gs ga gc gcp gp gpp (git verbs) and lg lgp lgpp lt
      (multi-repo tools) — provision your shell once:
        grove setup            # writes ~/.config/grove/aliases + one line in your rc
      then open a new shell. (`grove init <shell>` just prints the lines to eval.)
      Rename any alias that clashes on your system (e.g. gc, or lg vs lazygit).

      Run `grove` for an overview, or `grove --llm` for a machine-readable guide.
      `grove tree` and `grove overview`'s clickable repo links use Nerd Font icons —
      use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
