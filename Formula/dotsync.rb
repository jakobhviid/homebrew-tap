class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.10.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ec929e6836a9fe6d304034a5b8a2a5bab3f0e173e7636cc5667b0d1004d3566f"
    sha256 cellar: :any_skip_relocation, tahoe: "1c2195fd1ca1e2dd5e2864d3c1dcabe804423784e332b9d58d6bd665e21166ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "35a0206f8ba3a8db1e10590f8e6ad1bd3779e72659853c4344fd59d9af5fddb8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "1b901b264b5a85d0a940ade2f0f5a49c4ce81aa2d702184ca92183fe5cafd8e4"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "729bdd6e280f2d0725c9883d58943e2ba0fd597fbd90c62c1f7e5813b916d7a7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b53bc93c206f5662716b8159b464381a214c5524083435e9b2e0cc8a1bd1d8f7"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b1d38c2f191f0ebf05dc58d1f9f2f3ddf18d2f8e0f8d5e3e695ac102240e845d"
    end
  end

  def install
    bin.install "dotsync"
    generate_completions_from_executable(bin/"dotsync", "completions")
    (man1/"dotsync.1").write Utils.safe_popen_read(bin/"dotsync", "man")
  end

  test do
    assert_match "dotsync", shell_output("#{bin}/dotsync --help")
  end
end
