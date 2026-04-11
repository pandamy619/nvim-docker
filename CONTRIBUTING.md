# Contributing

Thanks for contributing to `nvim-docker`.

## Scope

This repository is a portable Neovim-in-Docker setup, not a full application dev environment. Changes should keep the project focused on:

- reproducible editor startup
- maintainable Docker targets
- predictable devcontainer/Codespaces behavior
- clear documentation for external users

## Before You Change Anything

- Read [README.md](README.md) or [README.ru.md](README.ru.md) for product scope.
- Read [docs/VERSION_POLICY.md](docs/VERSION_POLICY.md) before changing pinned versions, workflows, or release behavior.
- Prefer small, isolated commits when changing Docker targets, CI, or docs.

## Local Checks

Run the fast checks before opening a pull request:

```bash
bash -n devcontainer-conf/nv.sh
bash -n devcontainer-conf/smoke-test.sh
bash -n devcontainer-conf/devcontainer-ci-smoke-test.sh
python3 -m json.tool .devcontainer/devcontainer.json > /dev/null
python3 -m json.tool .devcontainer/base/devcontainer.json > /dev/null
python3 -m json.tool .devcontainer/go/devcontainer.json > /dev/null
python3 -m json.tool .devcontainer/web/devcontainer.json > /dev/null
python3 -m json.tool .devcontainer/full/devcontainer.json > /dev/null
git diff --check
```

If Docker is available, also validate at least one target locally:

```bash
docker build --target full -t my-dev-nvim ./devcontainer-conf
bash ./devcontainer-conf/smoke-test.sh my-dev-nvim full
```

## Change Expectations

- Keep versions pinned. Do not switch tooling to floating `latest` tags.
- Update both English and Russian documentation when user-facing behavior changes.
- Update [CHANGELOG.md](CHANGELOG.md) for notable repository changes.
- If you change devcontainer lifecycle commands, keep Codespaces prebuild behavior in mind.
- If you change release tags or image naming, update workflows and README examples together.

## Pull Requests

A good PR should include:

- what changed
- why it changed
- how it was verified
- any follow-up work left out on purpose

If a change is only partially verified because Docker or Codespaces could not be exercised locally, say that explicitly.

## Issues

- Use the bug report template for regressions or broken behavior.
- Use the feature request template for product or workflow changes.
- Questions about usage should generally start from the README, not a blank issue.
