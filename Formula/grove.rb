class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "2.0.4"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v2.0.4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b76dd4df59c1add485fe9046d637551ed32eb80bc3b5098f4bab755fa7af6089"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.4/grove-x86_64-apple-darwin.tar.gz"
      sha256 "360d0a71ba373f7f908ddbda9080fff5e9a7df9277c1c7f114416a8e68740463"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.4/grove-aarch64-apple-darwin.tar.gz"
      sha256 "8e94bec48232bf6828e6bbed8a445da5933c64b6105d072d751d4f7a1a5e51ae"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.4/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "af69fe0f23e19b3235a8528c18e95c2ad0d6d0ffd3c296762d373d75de8f3254"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v2.0.4/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "41db7f17eaa666b9ae90eadf673c33d11539161a538ff251965d0c5c2447e9b7"
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
