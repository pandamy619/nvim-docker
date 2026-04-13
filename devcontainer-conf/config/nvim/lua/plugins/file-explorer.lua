return {
  -- ===================================================================
  -- 🎨 ИКОНКИ ФАЙЛОВ
  -- ===================================================================
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- ===================================================================
  -- 🌳 ФАЙЛОВЫЙ МЕНЕДЖЕР NEO-TREE
  -- ===================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    -- Указываем зависимости, которые Neo-tree будет использовать
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- для иконок
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_hidden = false,
          },
        },
      })
    end,
  },
}
