class Chaar < Formula
  desc "Terminals on your machines, from anywhere"
  homepage "https://chaar.ai"
  version "0.1.0-alpha.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.7/chaar-aarch64-apple-darwin.tar.xz"
    sha256 "babbb76f20346670770e3913b7f3846b34359c43edf5f5ba009e7aa4ec28551f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.7/chaar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98ac2d3917bfefc68bc44e71be69e0848f4a876882ab97aed8f2a3521ea6f81d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sixtythreelabs/chaar-releases/releases/download/cli/v0.1.0-alpha.7/chaar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2c2fe2feb24b0ba1634aa1088b710c159321068486643fe1c060c06660e7bdd"
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
