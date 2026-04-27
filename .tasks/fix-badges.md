# Task: Fix the broken/misleading status badges in the nvim-docker README

## Context

Repo: github.com/pandamy619/nvim-docker (default branch: main).
Workflows directory: `.github/workflows/` contains three files:

| File | `name:` inside | Purpose |
|---|---|---|
| `ci.yml` | `CI` | Static checks + devcontainer matrix smoke test on push/PR |
| `release-check.yml` | `Release` | Builds 4 docker targets on push/PR (smoke build, does NOT publish) |
| `release.yml` | `Publish Release` | Publishes to GHCR, triggers only on tag `v*` push |

## Current badges in README.md (top of file, lines 3–5)

```markdown
[![CI](https://github.com/pandamy619/nvim-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/pandamy619/nvim-docker/actions/workflows/ci.yml)
[![Release](https://github.com/pandamy619/nvim-docker/actions/workflows/release-check.yml/badge.svg)](https://github.com/pandamy619/nvim-docker/actions/workflows/release-check.yml)
[![GHCR](https://img.shields.io/badge/GHCR-package-blue?logo=github)](https://github.com/pandamy619/nvim-docker/pkgs/container/nvim-docker)
```

## Two problems

1. The **"Release" badge points to `release-check.yml`** — that's a smoke-build workflow, not the actual GHCR-publishing release. It says "passing" while the real `release.yml` never gets reflected anywhere. Misleading.
2. **CI badge shows "no status"** on the repo page. The workflow exists on `origin/main` and was last touched in commit `a410006`. "no status" implies the latest run on `main` was cancelled / in_progress / skipped (not failed, which would render red).

## What to do

### Step 1 — Diagnose CI

```bash
gh run list --workflow=ci.yml --branch=main --limit 5
```

- If the latest run is `in_progress` → wait and report back.
- If `cancelled` or `skipped` → re-trigger with `gh workflow run ci.yml --ref main`.
- If a run is `failure` → fetch the failed job log with `gh run view <id> --log-failed` and report which step failed (do **not** attempt to fix the failure in this task — badge work only).

### Step 2 — Replace the three badge lines in README.md (top of file) with this block, exactly

```markdown
[![CI](https://github.com/pandamy619/nvim-docker/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/pandamy619/nvim-docker/actions/workflows/ci.yml)
[![Build](https://github.com/pandamy619/nvim-docker/actions/workflows/release-check.yml/badge.svg?branch=main&event=push)](https://github.com/pandamy619/nvim-docker/actions/workflows/release-check.yml)
[![Release](https://github.com/pandamy619/nvim-docker/actions/workflows/release.yml/badge.svg)](https://github.com/pandamy619/nvim-docker/actions/workflows/release.yml)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2Fpandamy619%2Fnvim--docker-blue?logo=github)](https://github.com/pandamy619/nvim-docker/pkgs/container/nvim-docker)
```

Changes vs current:
- CI badge: add `?branch=main&event=push` (filters out PR-run noise).
- "Release" → "Build" and points to `release-check.yml` — honest label for a smoke-build workflow.
- New "Release" badge points to the real `release.yml` (publishes to GHCR).
- GHCR badge: replace the static "package" text with the actual image path.

### Step 3 — Apply the same change to README.ru.md

If its top-of-file badges block matches, replace it with the same new block.

### Step 4 — Verify

- `git diff README.md README.ru.md` — confirm only the badge block changed.
- Sanity-check each badge URL (every href should be a working GitHub URL).
- Commit message: `docs(readme): fix and clarify status badges`
- **Do NOT push automatically** — leave the commit on the local branch for review.

## Acceptance criteria

- `README.md` and `README.ru.md` (if applicable) have the new 4-badge block.
- CI run status on `main` is identified (`in_progress` / `cancelled` / `failure` / `success`) and reported in the final summary.
- One commit on local branch, not pushed.
- No other files modified.
