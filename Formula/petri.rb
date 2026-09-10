class Petri < Formula
  desc "The petridish dashboard: a ratatui TUI over ~/.petridish/projects.json."
  homepage "https://github.com/JKrag/petridish"
  version "1.0.0-beta.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.3/petri-aarch64-apple-darwin.tar.xz"
      sha256 "67517caa42eb8dded0597c815f224c15248e9129dee74589113ecf7ed575ec63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.3/petri-x86_64-apple-darwin.tar.xz"
      sha256 "e4594862255a67f3d77e4636b532305038fe14e918a39d6254090784d161013b"
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
      bin.install "petri"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "petri"
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
