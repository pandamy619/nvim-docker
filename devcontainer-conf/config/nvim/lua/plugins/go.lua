return {
  "ray-x/go.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("go").setup()

    -- Горячие клавиши для удобства (опционально)
    local keymap = vim.keymap
    keymap.set("n", "<leader>gt", ":GoTestFunc<CR>", { desc = "Запустить тест для текущей функции [Go]" })
    keymap.set("n", "<leader>gf", ":GoTestFile<CR>", { desc = "Запустить тесты для файла [Go]" })
    keymap.set("n", "<leader>gr", ":GoRun<CR>", { desc = "Запустить программу (go run) [Go]" })
  end,
  -- Указываем, что этот плагин для файлов с типом 'go'
  ft = { "go", "gomod" },
}