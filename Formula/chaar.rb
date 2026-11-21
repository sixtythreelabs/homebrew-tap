class Chaar < Formula
  desc "Terminals on your machines, from anywhere"
  homepage "https://chaar.ai"
  version "0.1.0-alpha.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.6/chaar-aarch64-apple-darwin.tar.xz"
    sha256 "4764411b9d8e7f0061dc7cf02a79bf8743cba6b70271a8f8f99649566748d341"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.6/chaar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "47871661996b6e2d6586282f9c8f20ad709b5b167b4a9fc17957a1882f7b45cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.6/chaar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a47cc6553c1505c1235aa096f01348284dbcaca6905e979495ab1a6488877a1"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
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
