class Pst < Formula
  desc "Upload files and pastes to multiple sharing services with automatic fallback"
  homepage "https://github.com/jnylen/pst"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.3.0/pst-aarch64-apple-darwin.tar.xz"
      sha256 "3c5ebfad2844f5d4084508e81b575c5728bc278f2309c7a2a3455f2cf40bc08d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.3.0/pst-x86_64-apple-darwin.tar.xz"
      sha256 "07697c008c79e9fc2fd7d93ad361224a2a58effc1fa26b90446d10c3de3d0b39"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.3.0/pst-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d813b40e9a081686d9db51acd326a0b64a6618aa011343816f76fbb9454ccf9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.3.0/pst-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c789420a55c52b13c962875767493ea1736f8cbe2b8193da75b7b445317017f"
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
