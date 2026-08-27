# Pikos Homebrew tap

Notes, tasks, and calendar in one local-first app. https://pikos.app

```sh
brew tap pikos-app/tap
```

## The app

```sh
brew install --cask pikos
```

Or get the `.dmg` from [pikos.app/download](https://pikos.app/download). Same build either way.

## The beta

`pikos@beta` is a prerelease of 0.4.0, the release that adds external calendar sync. It has not finished its QA pass. Install it only if you want to help find what is still broken.

```sh
brew install --cask pikos-app/tap/pikos@beta
```

It is the same app, not a second one. Same bundle id, same workspace. Opening it upgrades that workspace to a newer schema, and that only goes one way: the stable app will refuse to open your data afterwards. Back up `~/Library/Application Support/app.pikos.desktop` before you switch, or run the beta on a machine with no Pikos data yet.

Going back means installing 0.3.x again and restoring that folder.

## The CLI

```sh
brew install pikos-app/tap/pikos-cli
```

`pikos` reads and writes the same local workspace the app uses. It also speaks MCP over stdio, so an agent can use it as a tool.

```sh
pikos today
pikos add "Draft the launch post friday 2pm #writing"
pikos search invoice
```

Node is a dependency of `pikos add` only. The natural-language parser is single-sourced in the TypeScript core and runs in a one-shot node subprocess; everything else is pure Rust against SQLite. Homebrew installs Node for you.

The CLI is a beta too, on the same footing as `pikos@beta`. It carries the 0.4.0 schema, so pointing it at a workspace that a 0.3.x app still owns will ask before upgrading it.

## Reporting something

Issues go to [Pikos-App/pikos](https://github.com/Pikos-App/pikos/issues), not here. This repo only holds the formulae.
