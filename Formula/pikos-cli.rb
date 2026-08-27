class PikosCli < Formula
  desc "Headless access to your local Pikos workspace"
  homepage "https://pikos.app/"
  version "0.4.0-beta.1"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.0-beta.1/pikos-cli-0.4.0-beta.1-aarch64-apple-darwin.tar.gz"
      sha256 "f51492df800cf223f939e8445c9eb5f32efe0a78f22853830dffa46688feed07"
    end
    on_intel do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.0-beta.1/pikos-cli-0.4.0-beta.1-x86_64-apple-darwin.tar.gz"
      sha256 "38be8d8cd1a04fd732a33f2f4531a3c67e4406ef79b1670e668579438bc58bf2"
    end
  end

  on_linux do
    url "https://github.com/pikos-app/pikos/releases/download/v0.4.0-beta.1/pikos-cli-0.4.0-beta.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "cfb8981597fd867e8747fe19ac311e84cc2d231eab7d142fb5a6f9630cbd69b9"
  end

  # Only `pikos add` needs it: the natural-language parser is single-sourced in
  # the TypeScript core and runs in a one-shot node subprocess. Every other
  # command is pure Rust against SQLite.
  depends_on "node"

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
