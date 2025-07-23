return {
  "nvim-lualine/lualine.nvim",
  -- Указываем зависимость от nvim-web-devicons для красивых иконок
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        -- Используем тему, которая хорошо сочетается с tokyonight
        theme = "tokyonight",
        -- Включаем иконки
        icons_enabled = true,
        -- Настраиваем разделители для секций
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
      },
      -- Настраиваем, что и в каком порядке будет отображаться
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', path = 1}}, -- Показывает имя файла и относительный путь
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    })
  end,
}