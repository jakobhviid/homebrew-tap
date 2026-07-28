class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "2.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v2.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9151bd3e59e310a2b8b3ddb3c6093521d9436487ca5d5eeecd0c35a0b3b8f9b"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.1.0/grove-x86_64-apple-darwin.tar.gz"
      sha256 "c5f1afdc60cdccd3062a1a4e9ca67d13fef0d6b4f4a9986ee4bccdce0b6a3237"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.1.0/grove-aarch64-apple-darwin.tar.gz"
      sha256 "2ce52b16b04edcc15d9df7bd9d6ea4d853e8f39ffdc78de7138ccdea2b202ac8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.1.0/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ce7e24df7f8df1a083d51963b8b884c8e382e185de02b351bb9f25226e697584"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.1.0/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "09905c78f7ad7b1488a628a6c75530c95a17397c89c3946fb67226683db7232f"
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
      The `lt` tree view uses Nerd Font icons — use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
