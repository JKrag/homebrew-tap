# JKrag/homebrew-tap

Homebrew formulae for [petridish](https://github.com/JKrag/petridish) — a local
monitoring daemon for macOS that tracks git state and AI agent activity across
your projects.

## Install

```sh
brew install jkrag/tap/petridish
petridish install
```

That one command is all you need: `petridish` depends on the `swab` and `petri`
formulae, so Homebrew pulls in all four binaries.

| Formula | Binaries | Role |
| --- | --- | --- |
| `petridish` | `petridish` | Install, uninstall, health-check, menu bar |
| `swab` | `swab`, `swab-hook` | The scanner — the only writer of `projects.json` |
| `petri` | `petri` | The terminal dashboard |

There are three formulae rather than one because they come from three crates,
and the crates are kept apart deliberately: `swab-hook` runs on every Claude Code
hook invocation and must not carry the dashboard's dependency tree. See
[ADR-0002](https://github.com/JKrag/petridish/blob/master/ADR-0002-petri-rust-workspace.md).

To remove everything, note that Homebrew leaves dependencies behind:

```sh
petridish uninstall          # unwire launchd + the Claude Code hook first
brew uninstall petridish && brew autoremove
```

## This repository is generated

Formulae here are published by
[cargo-dist](https://github.com/axodotdev/cargo-dist) from the petridish release
workflow. **Don't edit them by hand** — changes are overwritten on the next
release. File issues against
[JKrag/petridish](https://github.com/JKrag/petridish/issues).
