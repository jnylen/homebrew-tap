class Pst < Formula
  desc "Upload files and pastes to multiple sharing services with automatic fallback"
  homepage "https://github.com/jnylen/pst"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.5.0/pst-aarch64-apple-darwin.tar.xz"
      sha256 "75d9ef7ee06f3b0427a8a6fa9da32fa6c2aa5421cf33635f69d6a6da13a88b8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.5.0/pst-x86_64-apple-darwin.tar.xz"
      sha256 "b78427b1243d72fb626afa81530c8a637a24ac71d472ae4c47a1b59173106073"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.5.0/pst-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aed3d2e22b294bf2cae65240e3b486638b71f25c4083aef997b08608308c7eca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.5.0/pst-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e79fab5dc71ee6199cf1126549951acd318cb236228bcb721c9170e11d379d5f"
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
