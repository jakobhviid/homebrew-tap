class Grove < Formula
  desc "Portable git shortcuts plus a multi-repo overview & sync, for any shell"
  homepage "https://github.com/jakobhviid/grove"
  version "0.1.1"
  license "MIT"

  depends_on "git"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.1/grove-x86_64-apple-darwin.tar.gz"
      sha256 "66f76f4ef575b34938cef774f3929a235b50e68fb19759a8011576bfd881d2f5"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.1/grove-aarch64-apple-darwin.tar.gz"
      sha256 "82f9848dced460acb19a8494f0b4902937cb4d6c5cc5ee0dcc056d3fa32f4ffa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.1/grove-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f1803ecc550f7e392cb977637464242f6fafd32700eaf842ae76cf6aaebcb094"
    end
    on_arm do
      url "https://github.com/jakobhviid/grove/releases/download/v0.1.1/grove-aarch64-unknown-linux-musl.tar.gz"
      sha256 "83ce3041e6a383ec181844a6545b9cb4ffa341046795e91a59b5c2c387413c36"
    end
  end

  def install
    bin.install "grove"
    generate_completions_from_executable(bin/"grove", "completions")
    (man1/"grove.1").write Utils.safe_popen_read(bin/"grove", "man")
  end

  def caveats
    <<~EOS
      Enable the short aliases (gs, ga, gc, gcp, gp, gpp, lg, lgp, lt) by adding
      one line to your shell rc:

        zsh:   eval "$(grove init zsh)"
        bash:  eval "$(grove init bash)"
        fish:  grove init fish | source

      The `lt` tree view uses Nerd Font icons — use a Nerd Font for best results.
    EOS
  end

  test do
    assert_match "grove", shell_output("#{bin}/grove --help")
  end
end
