class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "2.0.3"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v2.0.3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b0f41b8009e3ba5068652d5a31cf5a30c957090d04cd76e3df978c2d7c33c89"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.3/grove-x86_64-apple-darwin.tar.gz"
      sha256 "dd3d9c892f8b88d8b9ff23777f026e5e782ef3e4c44a93a320d8c4888dd65974"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.3/grove-aarch64-apple-darwin.tar.gz"
      sha256 "a7625f3248e56f5e80d6dc64e94a3df35bb269fc6d6e5e93e7fb588d988a639d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.3/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b075925cd0d04273b1153ca72e21f9ce0df104ce8e00c4741615c20a236787c9"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.3/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dc68762dfc13a40c2c78b903d53214da5361749a81873b1dd923de32621fea2d"
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
