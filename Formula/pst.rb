class Pst < Formula
  desc "Upload files and pastes to multiple sharing services with automatic fallback"
  homepage "https://github.com/jnylen/pst"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.2.0/pst-aarch64-apple-darwin.tar.xz"
      sha256 "6d57389dd71c15f0aeb04d2847b72d36e0512b43d1e292f3877e4fa98cf5b6f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.2.0/pst-x86_64-apple-darwin.tar.xz"
      sha256 "1a935c1613160a95a9b0d92044240f121a1a020dcf6b14910c4faa1a7d9f0198"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.2.0/pst-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72e01277ac1c861af2554639745d43fe53a7955e34289c14134904fe6977a2ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.2.0/pst-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf73afa6a528ee7f33d74ffefb3edf30bacc5bc0cdc19c5b2fda231710c55f6e"
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
