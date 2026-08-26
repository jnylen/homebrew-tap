class Pst < Formula
  desc "Upload files and pastes to multiple sharing services with automatic fallback"
  homepage "https://github.com/jnylen/pst"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.6.1/pst-aarch64-apple-darwin.tar.xz"
      sha256 "7fd2799441e0f40a86abfc9278e2b7c0b66db532b4ece4a6acbed26a19d5f29e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.6.1/pst-x86_64-apple-darwin.tar.xz"
      sha256 "bb722123acb2a28e04b297c90555b7e77de023c47f754f1f4bd42feba83836d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/pst/releases/download/v0.6.1/pst-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49524808d44557f581c3dd7bdeed7f18155a12c16417e53090d502e3873ea58c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/pst/releases/download/v0.6.1/pst-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6003da34f1a7db3a2b3a608ad08fa52ef3a896c5aab793983ecf66c97ada40c8"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "pst"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pst"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pst"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pst"
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
