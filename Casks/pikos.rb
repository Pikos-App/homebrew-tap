cask "pikos" do
  version "0.5.0"
  sha256 "323f1d8acaa9dba217787f803f50b515fdf4a469e38d99efe723e6663e43fa30"

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
