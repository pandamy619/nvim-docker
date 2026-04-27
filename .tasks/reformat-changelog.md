# Task: Reformat CHANGELOG.md to Keep a Changelog format

## Context

The current `CHANGELOG.md` at the repo root contains correct content but is
not structured according to the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
spec. Each version is a flat bullet list — entries are not grouped under
`### Added`, `### Changed`, `### Fixed` subheadings, and the file lacks the
standard header references and compare links.

No translation work is needed — the file is already in English.

## What to do

Replace the entire contents of `CHANGELOG.md` (at the repo root) with the
**exact** text below. No other words. No additions. No reordering. No edits
to the wording of individual entries — they have been pre-categorized.

### New file content

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `release-check.yml` workflow so the Release badge reflects branch health instead of a tag-only publish workflow.

### Changed
- Renamed the tag-triggered workflow to `Publish Release` to distinguish publishing from release validation.

### Fixed
- Guarded terminal paste in non-editable Neovim buffers to avoid `E21` errors in special views such as file explorers and git panes.

## [0.2.0] - 2026-04-11

### Added
- CI and release matrix builds for all image profiles.
- Launcher support for selecting a local build target or pulling a prebuilt GHCR image.
- `.devcontainer` profiles for `base`, `go`, `web`, and `full`.
- Default `.devcontainer/devcontainer.json` pointing to the `full` profile.
- Prebuild-friendly devcontainer bootstrap via `onCreateCommand` for initial `Lazy sync`.
- CI and GHCR badges, plus a "30-second start" entry in the README.
- Contributor docs, issue templates, and a version update policy.
- Approximate profile comparison tables in both READMEs.

### Changed
- Split the Docker image into `base`, `go`, `web`, and `full` profiles.
- Switched Neovim installation from a source build to pinned official release tarballs.
- Upgraded GitHub Actions to Buildx-based multi-arch publishing with GitHub cache reuse.
- Reworked CI to validate real devcontainer flows through `devcontainers/ci`.

### Fixed
- Devcontainer startup by enabling `overrideCommand: true` for all profiles.

## [0.1.0] - 2026-04-11

### Added
- Embedded the default Neovim config into the image for direct GHCR runs.
- Bilingual documentation in English and Russian.
- CI smoke tests and a GHCR publish workflow for tagged releases.

### Changed
- Stabilized the Docker launcher and stopped tracking local Neovim runtime state.
- Reworked the Docker image into a multi-stage build with a smaller final runtime image.
- Replaced Mason-driven base LSP installation with bundled language servers inside the image.

### Fixed
- Go cache and `gopls` startup issues by creating and mounting proper XDG cache/state directories.

[Unreleased]: https://github.com/pandamy619/nvim-docker/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/pandamy619/nvim-docker/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/pandamy619/nvim-docker/releases/tag/v0.1.0
```

## Verify

```bash
git diff CHANGELOG.md | head -80
git status
```

The diff should be substantial — old plain-list format replaced with grouped
`### Added/Changed/Fixed` sections. `git status` must show ONLY `CHANGELOG.md`
modified, nothing else.

Spot-check the result:

```bash
head -20 CHANGELOG.md
tail -5 CHANGELOG.md
```

- `head -20` should start with `# Changelog`, mention Keep a Changelog 1.1.0
  and Semantic Versioning, then `## [Unreleased]` with `### Added` underneath.
- `tail -5` should end with the three compare-link reference definitions
  (`[Unreleased]:`, `[0.2.0]:`, `[0.1.0]:`).

## Do NOT commit

**Do NOT run `git add`, `git commit`, or `git push`.** Leave the change as
an unstaged modification in the working tree — the maintainer will review
and commit it manually.

## Acceptance criteria

- `CHANGELOG.md` now has the structure above with `### Added / ### Changed
  / ### Fixed` subsections under each version.
- The wording of every individual bullet point matches the original wording
  (no entries lost, none added, none reworded).
- Three compare-link reference definitions at the bottom of the file.
- Only `CHANGELOG.md` is modified — `git status` lists nothing else as
  modified or staged.
- The change is **unstaged**: `git diff --cached` is empty,
  `git diff CHANGELOG.md` shows the full reformat.
- Nothing committed, nothing pushed.
