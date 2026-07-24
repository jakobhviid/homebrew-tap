class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.5"
  license "MIT"

  # Prebuilt x86_64 Linux bottle: `brew install` pours it directly, so it needs
  # no C compiler / build tools (works on minimal & immutable distros). Other
  # platforms fall back to the url+install path below (Macs have the toolchain).
  bottle do
    root_url "https://github.com/jakobhviid/grove/releases/download/v0.1.5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb4e6fc0319bed26615928c5d95b0a519e96bd054c35bfafc63c98f8db83bbb8"
  end

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.5/grove-x86_64-apple-darwin.tar.gz"
      sha256 "85cba8f5decc47b14ee7d1b0610420adced49a278abe6ef481fe63da0d3622a4"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.5/grove-aarch64-apple-darwin.tar.gz"
      sha256 "8818093273cf5f30d153fbd874d38e3f1d68d8386eba51b79a67d1d7789e8f71"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.5/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aa6750fd3a26fd5ec2154b621f0607264d9c1d1e564eb8499272ae6c4f90148e"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.5/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "978192a4fbc64f8660dd1fdd30296aeaf98710f0396ab521fd44253094340c4a"
    end
  end

  def install
    # Each command is its own binary — no setup, works in any shell.
    bin.install %w[grove gst ga gc gp gpp lg lgp lt]
    generate_completions_from_executable(bin/"grove", "completions")
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
  end

  def caveats
    <<~EOS
      The commands work immediately in any shell — no setup:
        gst ga gc gp gpp   (git status / add / commit / pull / push)
        lg lgp lt          (multi-repo overview / sync / tree)
      Run `grove` for an overview.

      Optional short aliases (gs, gcp, …) via a grove file:
        grove example > ~/.config/grove/aliases     # then edit to taste
        eval "$(grove init zsh)"                     # zsh (or bash / fish)

      The `lt` tree view uses Nerd Font icons — use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
