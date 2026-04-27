# Task: Move generated social-preview assets into the repo

## Context

A social-preview image (1280×640) for the GitHub repo page has been generated
and currently sits at the repo root in an untracked `.assets/` folder:

```
.assets/social-preview.svg   ← source (vector, editable)
.assets/social-preview.png   ← 1280×640 export (the file maintainer uploads to GitHub)
```

`.assets/` is a temporary scratch dir and should NOT be committed as-is.
The repo already has a `docs/` directory (alongside `docs/VERSION_POLICY.md`
and `docs/CODESPACES_PREBUILD.md`), which is the natural home for asset files.

## What to do

### Step 1 — Move the files into the repo

```bash
mkdir -p docs/assets
mv .assets/social-preview.svg docs/assets/social-preview.svg
mv .assets/social-preview.png docs/assets/social-preview.png
rmdir .assets   # only succeeds if empty; leave the dir alone if not empty
```

### Step 2 — Sanity-check `.gitignore`

```bash
git check-ignore -v docs/assets/social-preview.svg docs/assets/social-preview.png
```

Both paths must NOT be ignored. If either one matches a `.gitignore` rule
(e.g. a blanket `*.png`), report which rule and stop — do not edit
`.gitignore` without explicit confirmation.

### Step 3 — Stage and verify

```bash
git add docs/assets/social-preview.svg docs/assets/social-preview.png
git status
```

`git status` must show **exactly** these two files staged as new, and nothing
else added or modified. If anything else is staged, unstage it.

### Step 4 — Commit

```bash
git commit -m "docs: add social preview asset (1280x640)"
```

**Do NOT push automatically** — leave the commit on the local branch.

## Important note (do not act on this)

This commit only stores the asset in the repo for archival and future
regeneration. The image actually shown on the GitHub repo page is set
separately by the maintainer via:

> Settings → General → Social preview → Edit → upload `docs/assets/social-preview.png`

That step is a manual UI action and cannot be automated by this task.

## Acceptance criteria

- `docs/assets/social-preview.svg` and `docs/assets/social-preview.png` exist
  on disk and are tracked by git.
- `.assets/` directory at repo root no longer exists (or is left untouched
  if it still contains other files — report which).
- One commit on the local branch, message exactly:
  `docs: add social preview asset (1280x640)`
- Only those two new files in the commit. No other changes.
- Nothing pushed.
