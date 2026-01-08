class Pst < Formula
  desc "Upload files and pastes to multiple sharing services with automatic fallback"
  homepage "https://github.com/jnylen/pst"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.1.0/pst-aarch64-apple-darwin.tar.xz"
      sha256 "45c58f603f12da871b51e86f4fd51dfee51830f1a8aabcd183649bdc479abcd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.1.0/pst-x86_64-apple-darwin.tar.xz"
      sha256 "f735130b196220bfd067535a0dc447d29417cbfb85328ce0f6fb344e30067829"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.1.0/pst-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "56311fd03e7cee90343359a5c26264fd2a8dfeeb0c41e198f10c9be72e814b0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.1.0/pst-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e319f2c40f21cee3f999ff4e8bb2d122ad85a6d7f39ea0fa749ddeb756cc45fb"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "pst" if OS.mac? && Hardware::CPU.arm?
    bin.install "pst" if OS.mac? && Hardware::CPU.intel?
    bin.install "pst" if OS.linux? && Hardware::CPU.arm?
    bin.install "pst" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
