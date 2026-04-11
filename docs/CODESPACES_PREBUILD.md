# Codespaces Prebuild Notes

This repository is prebuild-ready, but GitHub Codespaces prebuilds are enabled in repository settings, not through a tracked repository file.

## Default Recommendation

Use the default profile:

- `.devcontainer/devcontainer.json`

That profile maps to the `full` image target.

## Why This Repository Is Prebuild-Ready

- the repository has a default devcontainer
- profile-specific alternatives are available under `.devcontainer/*/devcontainer.json`
- lifecycle bootstrap uses `onCreateCommand`, which is compatible with Codespaces prebuild setup work

## Manual Enablement Steps

Repository admin steps on GitHub:

1. Open repository `Settings`.
2. Open `Codespaces`.
3. Open `Prebuild configurations`.
4. Add a configuration for branch `main`.
5. Select the default devcontainer: `.devcontainer/devcontainer.json`.
6. Choose the regions and machine type appropriate for your team.
7. Save the configuration and wait for the first prebuild to finish.

## What To Expect

- the first codespace create becomes faster after prebuilds are warm
- plugin bootstrap should already be handled during image/container preparation
- project-specific dependencies are still the responsibility of the target repository, not this editor image
