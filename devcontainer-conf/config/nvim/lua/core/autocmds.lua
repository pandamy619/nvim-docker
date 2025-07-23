local api = vim.api

-- Создаем группу автокоманд, чтобы они не дублировались при перезагрузке конфига
local TheRstFamily = api.nvim_create_augroup("TheRstFamily", { clear = true })

-- Создаем автокоманду, которая сработает при загрузке любой цветовой схемы
api.nvim_create_autocmd("ColorScheme", {
  group = TheRstFamily,
  pattern = "*",
  callback = function()
    -- Устанавливаем прозрачный фон для основных элементов
    api.nvim_set_hl(0, "Normal", { bg = "none" })      -- Активное окно
    api.nvim_set_hl(0, "NormalNC", { bg = "none" })   -- Неактивные окна
    api.nvim_set_hl(0, "NormalFloat", { bg = "none" })-- Всплывающие окна
    api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" }) -- Фон для Neo-tree
  end,
})