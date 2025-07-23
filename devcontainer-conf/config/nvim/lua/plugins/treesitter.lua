return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Команда для обновления парсеров
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Список языков для установки. Вы можете добавить или убрать нужные.
      ensure_installed = {
        "c", "cpp", "go", "lua", "python", "rust", "sql", "typescript",
        "javascript", "html", "css", "json", "yaml", "toml", "bash",
        "vim", "vimdoc", "dockerfile", "gitignore"
      },

      -- Устанавливать парсеры синхронно (для ленивой загрузки)
      sync_install = false,

      -- Автоматически устанавливать парсеры для языков, которые вы открываете
      auto_install = true,

      -- Включить модуль подсветки синтаксиса
      highlight = {
        enable = true,
      },
    })
  end,
}