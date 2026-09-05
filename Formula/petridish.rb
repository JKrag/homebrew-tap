class Petridish < Formula
  desc "Install, verify and drive petridish: the launchd daemon, the Claude Code hook, and the menu-bar plugin."
  homepage "https://github.com/JKrag/petridish"
  version "1.0.0-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.1/petri-dish-aarch64-apple-darwin.tar.xz"
      sha256 "501a4c18c779d103c08bf5de5b54bd9fdd0b3982d5aef42bb4fa59fcf07fef41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.1/petri-dish-x86_64-apple-darwin.tar.xz"
      sha256 "d15aa6b8ab8e134e47f511ac7da6aee4f0545dbc297392d8a3a6ac79efc78f6a"
    end
  end
  license "GPL-3.0-or-later"
  depends_on "jkrag/tap/petri"
  depends_on "jkrag/tap/swab"

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
      bin.install "petridish"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "petridish"
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
