# Task: Clean up status badges — rename smoke-test workflow and drop "Publish Release"

## Context

Repo: github.com/pandamy619/nvim-docker (default branch: main).

Two cosmetic issues remain on the badge row:

1. **Two badges visually display the word "Release."** The SVG text comes from
   each workflow's `name:` field, not the markdown alt text. The middle badge
   (`release-check.yml`, `name: Release`) is a smoke-test, not a real release.
2. **"Publish Release no status"** is technically correct but visually noisy.
   That badge belongs to `.github/workflows/release.yml` which only triggers
   on `push tag v*`; no tag has been pushed since the workflow was added.
   The user wants this badge **removed** until releases happen on a regular
   cadence.

Current rendered state:

```
[CI passing]  [Release passing]  [Publish Release no status]  [GHCR ghcr.io/...]
```

Target state:

```
[CI passing]  [Build passing]  [GHCR ghcr.io/...]
```

## What to do

### Step 1 — Rename the smoke-test workflow

In `.github/workflows/release-check.yml`, change the first line from:

```yaml
name: Release
```

to:

```yaml
name: Build
```

That's the **only** change to that file. Do not touch the `on:` block, jobs,
steps, matrix, or anything else. Do not modify `ci.yml` or `release.yml`.

### Step 2 — Remove the "Publish Release" badge from both READMEs

In `README.md` (top of file, badge block), delete this single line:

```markdown
[![Release](https://github.com/pandamy619/nvim-docker/actions/workflows/release.yml/badge.svg)](https://github.com/pandamy619/nvim-docker/actions/workflows/release.yml)
```

The remaining three badges (CI / Build / GHCR) stay exactly as they are.

Apply the **same** deletion to `README.ru.md` (it has an identical badge block
at the top). Only that one line is removed; nothing else changes.

### Step 3 — Verify

```bash
git diff .github/workflows/release-check.yml README.md README.ru.md
```

Expected diff:
- `release-check.yml`: one line, `-name: Release` → `+name: Build`.
- `README.md`: one line removed (the `[![Release]...release.yml...]` line).
- `README.ru.md`: same one line removed.

Confirm no other files changed:

```bash
git status
```

### Step 4 — Commit

Single commit, message:

```
docs(readme): drop unused Publish Release badge and rename smoke-test workflow to Build
```

**Do NOT push automatically** — leave the commit on the local branch for review.

## Why the markdown alt text doesn't need updating

The README already uses `[![Build](...)]` in the markdown for the smoke-test
badge. After the workflow rename, the SVG itself will render "Build", matching
the alt text. No further README change is needed for that badge.

## Acceptance criteria

- `.github/workflows/release-check.yml` line 1 is `name: Build`.
- The `[![Release](...release.yml...)]` line is gone from `README.md` and
  `README.ru.md`.
- Only those three files are modified (`git status`).
- One commit on local branch, not pushed.
- After the next push to main, the badge row renders as:
  `[CI passing] [Build passing] [GHCR ghcr.io/...]` — no duplicate "Release"
  wording, no "no status" badge.

## Future note (do not act on this now)

When a real release is published (`git tag v0.x.y && git push --tags`),
consider re-adding the `Publish Release` badge. The line to restore would be:

```markdown
[![Publish Release](https://github.com/pandamy619/nvim-docker/actions/workflows/release.yml/badge.svg)](https://github.com/pandamy619/nvim-docker/actions/workflows/release.yml)
```
