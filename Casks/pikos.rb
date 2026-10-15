cask "pikos" do
  version "0.4.1"
  sha256 "bb9a6c825f43f1ef865d0ec4831492f42155c021278b092f39978496f9d57690"

  url "https://github.com/pikos-app/pikos/releases/download/v#{version}/Pikos-macos-universal.dmg"
  name "Pikos"
  desc "Local-first notes, tasks, and calendar in one app"
  homepage "https://pikos.app/"

  # Ships its own updater, so Homebrew should not treat a self-updated copy as
  # an outdated install.
  auto_updates true
  conflicts_with cask: "pikos@beta"
  depends_on macos: :big_sur

  app "Pikos.app"

  # Your workspace lives in Application Support. `brew uninstall` leaves it
  # alone; only `--zap` takes it, which is what zap is for.
  zap trash: [
    "~/Library/Application Support/app.pikos.desktop",
    "~/Library/Caches/app.pikos.desktop",
    "~/Library/Logs/app.pikos.desktop",
    "~/Library/Saved Application State/app.pikos.desktop.savedState",
    "~/Library/WebKit/app.pikos.desktop",
  ]
end
