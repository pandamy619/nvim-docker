# Changelog

All notable changes to this project will be documented in this file.

## v0.1.0 - 2026-04-11

- Stabilized the Docker launcher and stopped tracking local Neovim runtime state.
- Reworked the Docker image into a multi-stage build with a smaller final runtime image.
- Replaced Mason-driven base LSP installation with bundled language servers inside the image.
- Fixed Go cache and `gopls` startup issues by creating and mounting proper XDG cache/state directories.
- Embedded the default Neovim config into the image for direct GHCR runs.
- Added bilingual documentation in English and Russian.
- Added CI smoke tests and a GHCR publish workflow for tagged releases.
