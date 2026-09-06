class Swab < Formula
  desc "The petridish scanner: crawls project roots, reads git state, senses agent activity."
  homepage "https://github.com/JKrag/petridish"
  version "1.0.0-beta.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.2/swab-aarch64-apple-darwin.tar.xz"
      sha256 "5171c9f29940deca3196d63bfe1bc66b9ed21b7643d965b74053231fee7d4bcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.2/swab-x86_64-apple-darwin.tar.xz"
      sha256 "66a90f43b13a76b0841f4e2c6b0ce2774d0d1e582e31087c64e61f5b2376e663"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "swab", "swab-hook"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "swab", "swab-hook"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
