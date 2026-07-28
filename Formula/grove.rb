class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "2.3.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v2.3.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fb1f744e8dbe19b72a5d4d34ad6413cba6289e33329b5a02dc280286dbe1b379"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.3.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "3f64e74d32a217aee2ee1867d81e1754e9c84303dea73bb93a80e7e046245d0f"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.3.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "4b2830f42a02b74bd22cf7f0bee593707803aae45a16ea0d0e1484454835db65"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.3.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "30d69daaa0a652deacf3fac8ea4761d1471107108a9a4f83ade3ca76000d4c7e"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.3.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1593d0f1d7025d788e25c22fb1404f3acc435ce4de497b5607ca1ec53824b7a6"
    end
  end

  def install
    # grove bundles the git verbs (status/add/commit/pull/push) as subcommands;
    # the multi-repo/tree tools are their own binaries.
    bin.install %w[grove lg lgp lgpp lt]
    # `grove completions <shell>` emits the suite's completions. For zsh it's a
    # single `_grove` file tagged for grove + lg/lgp/lgpp/lt (and the short
    # aliases inherit grove's completion); bash/fish cover `grove` itself.
    generate_completions_from_executable(bin/"grove", "completions")
    # Man pages: grove has a `man` subcommand; lg/lgp/lgpp/lt render theirs with
    # a hidden `--man` flag.
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
    %w[lg lgp lgpp lt].each do |c|
      (man1/"#{c}.1").write Utils.safe_popen_read(bin/c, "--man")
    end
  end

  def caveats
    <<~EOS
      The multi-repo/tree tools work immediately — no setup:
        lg lgp lgpp lt     (overview / sync / bulk-push / tree)

      The everyday git verbs are `grove` subcommands:
        grove status / add / commit / pull / push

      For the short names (gs ga gc gcp gp gpp), provision your shell once:
        grove setup            # writes ~/.config/grove/aliases + one line in your rc
      then open a new shell. (`grove init <shell>` just prints the lines to eval.)
      Rename any alias that clashes on your system (e.g. gc) in the grove file.

      Run `grove` for an overview, or `grove --llm` for a machine-readable guide.
      The `lt` tree view and `lg`'s clickable repo links use Nerd Font icons —
      use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
