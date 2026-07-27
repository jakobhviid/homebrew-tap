class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "2.0.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v2.0.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "008ef50f44c9bcbb2119a17e72cd1daae840a592bbff29758772ac5a4cad71ee"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.2/grove-x86_64-apple-darwin.tar.gz"
      sha256 "465939a475b8066ef40c965ce634d1bdbbeeba7efd8213374eb73c6509e00c83"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.2/grove-aarch64-apple-darwin.tar.gz"
      sha256 "36c56ec59c2dd8b734044b2100edcdb9ac6f0e5f811b71853b6db6247fbfe61b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.2/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "407dfe45599ec3f8c2242cb0ee2b239754bce6d32a8fd19b7e9810dabf013f44"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.2/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "03068fd5d0545cab4c6214e5e1b7705866cf0421d16a34e4855425433dbd2ce9"
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
