class Iptop < Formula
  desc "Look up IP addresses or display current ip"
  homepage "https://github.com/jnylen/iptop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/iptop/releases/download/v0.1.0/iptop-aarch64-apple-darwin.tar.xz"
      sha256 "dd2280255a18309f3944eba753b99bb1005b871ffd3bbe6ed99d5dd99339df92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/iptop/releases/download/v0.1.0/iptop-x86_64-apple-darwin.tar.xz"
      sha256 "31a7419146db49baa037251445ce023a3b1b82199c3b07e97449434c53db532f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jnylen/iptop/releases/download/v0.1.0/iptop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "629387feef19cdc38aa581e5e303ea6685d6c32d6dbe2b2ce59fe0a99a5b4cdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jnylen/iptop/releases/download/v0.1.0/iptop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5724c2fb7a012b8896fc301b08b702fa8788a681beeb4638c0d32e6b3ace0e20"
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
    bin.install "iptop" if OS.mac? && Hardware::CPU.arm?
    bin.install "iptop" if OS.mac? && Hardware::CPU.intel?
    bin.install "iptop" if OS.linux? && Hardware::CPU.arm?
    bin.install "iptop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
