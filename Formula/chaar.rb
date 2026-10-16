class Chaar < Formula
  desc "Terminals on your machines, from anywhere"
  homepage "https://chaar.ai"
  version "0.1.0-alpha.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.1/chaar-aarch64-apple-darwin.tar.xz"
      sha256 "4b4737597b064760378b9ce8dc3bbf009f28b19abd465c8fcb66ae9ffcdc2a6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.1/chaar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "331cffda9909d0e9eb38a4143ec833e2e4a4d0a4a18c4541856caaf3be283536"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.1/chaar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42f324de16618ce551d37a9b0608872883a11e976d1f5c9feeef459562b4a5a3"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-pc-windows-gnu": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "chaar"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "chaar"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "chaar"
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
