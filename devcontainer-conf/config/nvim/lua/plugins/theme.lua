return {
  "folke/tokyonight.nvim",
  lazy = false, -- Загружаем тему сразу при старте
  priority = 1000, -- У темы высокий приоритет загрузки
  config = function()
    require("tokyonight").setup({
      style = "storm", -- Варианты: "night", "day", "moon"

      -- 👇 ДОБАВЬТЕ ЭТУ СТРОКУ
      transparent = true, -- Включает прозрачный фон для темы
    })

    -- Применяем цветовую схему
    vim.cmd.colorscheme("tokyonight")
  end,
}