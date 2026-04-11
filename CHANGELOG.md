# Changelog

All notable changes to this project will be documented in this file.

## v0.2.0 - 2026-04-11

- Split the Docker image into `base`, `go`, `web`, and `full` profiles.
- Added CI and release matrix builds for all image profiles.
- Added launcher support for selecting a local build target or pulling a prebuilt GHCR image.
- Added `.devcontainer` profiles for `base`, `go`, `web`, and `full`.
- Added a default `.devcontainer/devcontainer.json` that points to the `full` profile.
- Added prebuild-friendly devcontainer bootstrap via `onCreateCommand` for initial `Lazy sync`.
- Fixed devcontainer startup by enabling `overrideCommand: true` for all profiles.
- Switched Neovim installation from a source build to pinned official release tarballs.
- Upgraded GitHub Actions to Buildx-based multi-arch publishing with GitHub cache reuse.
- Added CI/GHCR badges and a faster "30-second start" README entry.
- Reworked CI to validate real devcontainer flows through `devcontainers/ci`.
- Added contributor docs, issue templates, and a version update policy.
- Added approximate profile comparison tables to both READMEs.

## v0.1.0 - 2026-04-11

- Stabilized the Docker launcher and stopped tracking local Neovim runtime state.
- Reworked the Docker image into a multi-stage build with a smaller final runtime image.
- Replaced Mason-driven base LSP installation with bundled language servers inside the image.
- Fixed Go cache and `gopls` startup issues by creating and mounting proper XDG cache/state directories.
- Embedded the default Neovim config into the image for direct GHCR runs.
- Added bilingual documentation in English and Russian.
- Added CI smoke tests and a GHCR publish workflow for tagged releases.
