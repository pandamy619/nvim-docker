# nvim-docker: Roadmap

## 🔥 Quick wins (сегодня)

- [ ] **Починить/убрать бейджи** — проверить почему CI и Release показывают "no status" на главной. Если кэш не обновился — подождать; если Release триггерится только вручную, добавить `?branch=main` к URL или убрать бейдж.
- [ ] **Переписать описание репы** — сейчас сухое "Portable Neovim in Docker with devcontainer profiles...". Сделать с глаголом и выгодой: «Open any project in an isolated Neovim editor — same setup on every machine, no local LSP installs».
- [ ] **Social preview image** — Settings → General → Social preview, загрузить 1280×640. Можно использовать кадр из gif.
- [ ] **Добавить топики**: `nvim`, `neovim-config`, `dotfiles`, `dev-environment`, `reproducible-builds`.

## 🛠 Этим вечером

- [ ] **Создать `good first issue`** — реальный, не фейковый. Например: «Add fish/zsh shell support to base image» или «Document how to add a new language profile».
- [ ] **Раздел Comparison в README** — таблица: nvim-docker vs Devbox vs Devpod vs ручной dotfiles+Docker vs LunarVim/AstroNvim. Что выигрываешь, что теряешь.
- [ ] **Скриншоты редактора в README** — отдельно от gif. Подсветка кода, neo-tree открытый, LSP hover, gitsigns в gutter. Один скриншот в раздел «What You Get».
- [ ] **Причесать CHANGELOG.md** — привести к формату Keep a Changelog (`### Added`, `### Changed`, `### Fixed`). Перевести русские записи если есть.

## 📣 На выходные

- [ ] **Пост на r/neovim** — угол: «Reproducible Neovim across machines without dotfile-syncing» или «Onboarding new devs into a polyglot codebase». Готовиться отвечать на комментарии 2-3 часа после поста.
- [ ] **Show HN** — будний день, утро по PST. Заголовок технический, не маркетинговый.
- [ ] **Pretty README** — посмотреть на `folke/lazy.nvim` и `LazyVim/LazyVim`, переделать верх README в маркетинг-обложку (большой скриншот + 3 buy-in пункта крупно через HTML).
- [ ] **Видео 60-90 сек на YouTube (Unlisted)** — «переезжаю на новую машину за 30 секунд: clone, run, code». Ссылка в README.

## 🐢 В фоне

- [ ] **Контрибьютить в смежные репы** — отвечать в issue/discussions у `lazy.nvim`, `nvim-lua/kickstart.nvim` когда релевантно. В подписи упоминать nvim-docker.
- [ ] **Регулярные мелкие коммиты** — раз в неделю минимум, чтобы график был зелёным.
- [ ] **Релизы с понятными названиями** — не `v0.3.0`, а `v0.3.0: Add Rust profile and faster first-run`.
