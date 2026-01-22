class Pst < Formula
  desc "Upload files and pastes to multiple sharing services with automatic fallback"
  homepage "https://github.com/jnylen/pst"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.4.0/pst-aarch64-apple-darwin.tar.xz"
      sha256 "64134ab49e89d72edc75e09e6c30349ca4be6b5c35fd4bee402f031e72b2948b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.4.0/pst-x86_64-apple-darwin.tar.xz"
      sha256 "8a4d2960d0ee4ad1ec2c13bdcc30421d6ecb12b5918ea4df4d5bbfdd79fbfdc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.4.0/pst-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ef1adfc4a88f0c6a702b41e02b9ac3b90e46dd47471be7732548db9638abaac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.4.0/pst-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "580f028498600f66c161333b650fd0db05f99dda903cbf2e1095acf5ea0afd56"
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
