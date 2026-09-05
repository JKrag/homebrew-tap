class Swab < Formula
  desc "The petridish scanner: crawls project roots, reads git state, senses agent activity."
  homepage "https://github.com/JKrag/petridish"
  version "1.0.0-beta.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.1/swab-aarch64-apple-darwin.tar.xz"
      sha256 "5beac3ae4e1c2d193c8cdfb959b4bf4128fdaf3e9d1a670516cb7ff458b83a30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JKrag/petridish/releases/download/v1.0.0-beta.1/swab-x86_64-apple-darwin.tar.xz"
      sha256 "b34e316ad42718a61b6d4b749c0f918074c56d12f1d57e8d04e5cddea9943e94"
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
