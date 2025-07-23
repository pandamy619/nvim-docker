return {
  -- ===================================================================
  -- ➡️  GITSIGNS: Метки изменений в коде (остается без изменений)
  -- ===================================================================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local keymap = vim.keymap
          -- ... все горячие клавиши для gitsigns остаются теми же ...
          keymap.set("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Следующее изменение" })

          keymap.set("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, buffer = bufnr, desc = "Предыдущее изменение" })

          keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Застейджить изменение (hunk)" })
          keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Отменить изменение (hunk)" })
          keymap.set("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr, desc = "Застейджить выделенное" })
          keymap.set("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr, desc = "Отменить выделенное" })
          keymap.set("n", "<leader>gb", gs.blame_line, { buffer = bufnr, desc = "Показать blame для строки" })
        end
      })
    end,
  },

  -- ===================================================================
  -- 🧙 NEOGIT: Полноценный интерфейс для Git (замена Lazygit)
  -- ===================================================================
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- Необходимая библиотека
      "sindrets/diffview.nvim",        -- Для красивого просмотра изменений (diff)
      "nvim-telescope/telescope.nvim", -- Опционально, для улучшенного выбора
    },
    config = function ()
        require('neogit').setup({})
    end,
  },
}