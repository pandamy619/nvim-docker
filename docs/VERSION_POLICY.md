# Version Policy

This repository uses pinned versions for Neovim, bundled language tools, and GitHub Actions.

## Goals

- reproducible images
- predictable releases
- controlled upgrades

## What Must Stay Pinned

- Neovim release version in `devcontainer-conf/Dockerfile`
- bundled language tools such as `gopls`, `goimports`, `pyright`, `typescript-language-server`, `lua-language-server`, and `rust-analyzer`
- GitHub Actions major versions in workflow files

Avoid replacing pinned versions with floating `latest` values.

## Update Cadence

- Neovim: review new stable releases every 2 to 4 weeks
- Bundled language tools: review monthly, or earlier for critical compatibility/security fixes
- GitHub Actions: review monthly or when deprecations are announced
- Base image/runtime versions: review monthly together with CI results

## Release Semantics

- Patch release:
  docs updates, CI fixes, pinned tool refreshes, non-breaking bootstrap improvements
- Minor release:
  new profiles, new bundled tooling, new public workflows, notable user-facing behavior changes
- Major release:
  breaking launcher changes, profile removals/renames, incompatible workflow or image naming changes

## Upgrade Rules

- Update one logical group at a time when possible.
- Run the repository checks after every version bump.
- Note meaningful compatibility changes in `CHANGELOG.md`.
- If an upgrade changes startup behavior, update both READMEs in the same change.

## Pre-Release Checklist for Version Bumps

- Dockerfile pins updated intentionally
- workflows still match published image tags
- README examples still match current tags and profiles
- changelog updated
- CI green on `main`
