class Petridish < Formula
  desc "Install, verify and drive petridish: the launchd daemon, the Claude Code hook, and the menu-bar plugin."
  homepage "https://github.com/JKrag/petridish"
  version "1.0.0-beta.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.6/petri-dish-aarch64-apple-darwin.tar.xz"
      sha256 "259a9a8fd34386bb1688b5e3b6ef9b4f56395a1a1bb370d99f749d581c4337e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.6/petri-dish-x86_64-apple-darwin.tar.xz"
      sha256 "05a96573d455bb4992ff04fbae927c8b34ddc9fc05ec3e47f3f13f619fb67bc3"
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
