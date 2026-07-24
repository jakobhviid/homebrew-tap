class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.2"
  license "MIT"

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.2/grove-x86_64-apple-darwin.tar.gz"
      sha256 "bbc344878caac645552a4d02c8f1bbd264b78021d5caaec32d6f5e3cb920b05a"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.2/grove-aarch64-apple-darwin.tar.gz"
      sha256 "8fd329c22f6c10a6987df0fd337e8e3b88fe98723dff87389138a01e5eab515c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.2/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0374d36cdefe39856c9935cc118d76ec129412489f248ca27d43c8fcded44945"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.2/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bd7dd69d759ff88fe65d6d7e60c8181b984b7bfda8877d559888c4606a6321d2"
    end
  end

  def install
    bin.install "grove"
    # Short commands are symlinks to grove (it dispatches on the invoked name),
    # so they work in any shell with no setup.
    %w[gst ga gc gcp gp gpp lg lgp lt].each do |name|
      bin.install_symlink "grove" => name
    end
    generate_completions_from_executable(bin/"grove", "completions")
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
  end

  def caveats
    <<~EOS
      The short commands work immediately in any shell — no setup:
        gst ga gc gcp gp gpp   (git status/add/commit/commit+push/pull/push)
        lg lgp lt              (multi-repo overview / sync / tree)

      Optional: `grove init zsh|bash|fish` prints them as shell aliases instead,
      if you'd rather alias them or rename them.

      The `lt` tree view uses Nerd Font icons — use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
