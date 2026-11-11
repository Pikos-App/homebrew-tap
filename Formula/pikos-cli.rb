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
      url "https://github.com/pikos-app/pikos/releases/download/v0.5.0/pikos-cli-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "1ef23ef94e5268df4c432569874692936ae7947c5844692ea12133b0ef24bc45"
    end
    on_intel do
      url "https://github.com/pikos-app/pikos/releases/download/v0.5.0/pikos-cli-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "c329aac72143b88423d28dc133b8b92a2c76d3d40d1281d7a489abf5aabdcb26"
    end
  end

  # Nested inside `on_intel` rather than sitting directly in `on_linux`, which
  # current Homebrew refuses to parse. Only x86_64 is published.
  on_linux do
    on_intel do
      url "https://github.com/pikos-app/pikos/releases/download/v0.5.0/pikos-cli-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd665368a916050e4dc7ca969290b16f82b89b3715a3a332ef785bdd57cf65bb"
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
