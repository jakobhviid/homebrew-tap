class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "2.0.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v2.0.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6301c2dba0e143586c1414e381c777d70448e1efd4e5c1d27d552ccf4a970c28"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "86a00c3060fd29e574d99c92bdd6944031f4c406090806de4c6eddfe638c3552"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "cf5cdff66ff91e267e112715dc67ef09505d8631ac19c28bd903b2bd7aca4dda"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "57e7ad36eb166781f7c291b754c9800d652139fd4dc2670742d87d22995d9d26"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1e5a159d6cad70a94d2dd94d60786ad5cae54b06472d321fe5530833674289dd"
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
