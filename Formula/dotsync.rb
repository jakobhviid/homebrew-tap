class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.0.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.0.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "01cb8ce1a63e4336fcad526f140658b78e224aefc6aefb3a236ff51d97899999"
    sha256 cellar: :any_skip_relocation, tahoe: "153da049acb1833baca6f64aec65e5331454852b925306330fda6fd3f414da09"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "caab95651ca02cfe68bcd992845d8d2b798f92be10f1ebb8edfea755b87023b2"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.0.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "17c734dc73c4bd0094a0665e5ecbcdabda22fdc4bfe1aafb163a32b13b44f047"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.0.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "9f6446ef5c150b32f9675a5ea2d3dc8c3a0f4e466b3a57a5f1efb18a04f207ba"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.0.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4536eefda16ddf4c596eac4f163fa55f3b6114d267f75635a85ccc82f02559de"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.0.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b6f7b65de324612dcd2e1a5a1495138485f4c7732df5fed3ca72354c1e5e738d"
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
