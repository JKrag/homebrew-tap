class Swab < Formula
  desc "The petridish scanner: crawls project roots, reads git state, senses agent activity."
  homepage "https://github.com/JKrag/petridish"
  version "1.0.0-beta.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.4/swab-aarch64-apple-darwin.tar.xz"
      sha256 "714967d093aefada3c7aae88598b6940600cd3695977c29e98ed4d9ade2330a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.4/swab-x86_64-apple-darwin.tar.xz"
      sha256 "119d464997933090d3f2027ebc8f13158e779e169e4ce1b8eb458ac91cde196a"
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
