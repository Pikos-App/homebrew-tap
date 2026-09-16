class PikosCli < Formula
  desc "Headless access to your local Pikos workspace"
  homepage "https://pikos.app/"
  version "0.4.0-beta.3"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.0-beta.3/pikos-cli-0.4.0-beta.3-aarch64-apple-darwin.tar.gz"
      sha256 "9b84ca79c5bd5108f14ca8684697e2b49c9077388da52cb8ce6cce38cd341fbf"
    end
    on_intel do
      url "https://github.com/pikos-app/pikos/releases/download/v0.4.0-beta.3/pikos-cli-0.4.0-beta.3-x86_64-apple-darwin.tar.gz"
      sha256 "feac411478bed573cf4bafd531881f8af47a60ee3537ca23822ae331d7ea5dd0"
    end
  end

  on_linux do
    url "https://github.com/pikos-app/pikos/releases/download/v0.4.0-beta.3/pikos-cli-0.4.0-beta.3-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4e45495b1e0263258118e022111a7081dee1b08b2ce43995eee9026249035b38"
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
