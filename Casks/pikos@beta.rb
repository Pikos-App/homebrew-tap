cask "pikos@beta" do
  version "0.4.0-beta.3"
  sha256 "9c5b54e2c0089f032ea8774a727ca3078ee2c18094376625fe0250875eee571a"

  url "https://github.com/pikos-app/pikos/releases/download/v#{version}/Pikos-macos-universal.dmg",
      verified: "github.com/pikos-app/pikos/"
  name "Pikos Beta"
  desc "Local-first notes, tasks, and calendar in one app (prerelease)"
  homepage "https://pikos.app/"

  auto_updates true
  conflicts_with cask: "pikos"
  depends_on macos: :monterey

  app "Pikos.app"

  # Same bundle id and same workspace as the stable app, so the two are one
  # install, not two. Opening the beta upgrades the workspace schema and that
  # only goes one way: the stable app will refuse to open it afterwards. Back up
  # ~/Library/Application Support/app.pikos.desktop before switching.
  caveats <<~CAVEATS
    This is a prerelease. It shares its workspace with the stable app and
    upgrades that workspace one-way, after which Pikos 0.3.x can no longer
    open it. Back up ~/Library/Application Support/app.pikos.desktop first.
  CAVEATS

  zap trash: [
    "~/Library/Application Support/app.pikos.desktop",
    "~/Library/Caches/app.pikos.desktop",
    "~/Library/Logs/app.pikos.desktop",
    "~/Library/Saved Application State/app.pikos.desktop.savedState",
    "~/Library/WebKit/app.pikos.desktop",
  ]
end
