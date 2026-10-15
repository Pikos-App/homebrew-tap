class PikosCli < Formula
  desc "Headless access to your local Pikos workspace"
  homepage "https://pikos.app/"
  license "BUSL-1.1"

  # Only `pikos add` needs it: the natural-language parser is single-sourced in
  # the TypeScript core and runs in a one-shot node subprocess. Every other
  # command is pure Rust against SQLite.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.1/pikos-cli-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "f4d02fa8112dd618a67da4c39e3bc457ad1df780ceb638555f307c0741e0ee90"
    end
    on_intel do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.1/pikos-cli-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "1c61b5594185d7f5f5053eb4cb32ff9fd1ea479bf31fca91b9edf60a8440792a"
    end
  end

  # Nested inside `on_intel` rather than sitting directly in `on_linux`, which
  # current Homebrew refuses to parse. Only x86_64 is published.
  on_linux do
    on_intel do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.1/pikos-cli-0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2d47cf9ceffb66a257d2719bb673af116b9e8cc13f276b8a08d44fc13016f8d"
    end
  end

  def install
    libexec.install "bin/pikos"
    libexec.install "bridge"
    # Pinned rather than left to the binary's relative lookup, which resolves
    # against the real executable path and would miss the bridge if Homebrew's
    # bin entry were ever followed differently.
    (bin/"pikos").write_env_script libexec/"pikos",
                                   PIKOS_BRIDGE_JS: libexec/"bridge/bridge.mjs"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pikos --version")
    # No workspace in the sandbox, so the failure is the expected one and the
    # exit code is the contract.
    output = shell_output("#{bin}/pikos --db #{testpath}/missing.db today 2>&1", 5)
    assert_match "No Pikos workspace found", output
  end
end
