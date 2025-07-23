local keymap = vim.keymap -- для краткости

-- Устанавливаем <Space> как основную клавишу-лидера
vim.g.mapleader = " "

-- ⚡️ Полезные горячие клавиши
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Сохранить файл" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Выйти" })

-- Навигация по окнам
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Перейти в окно слева" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Перейти в окно снизу" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Перейти в окно сверху" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Перейти в окно справа" })

keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Открыть/Закрыть файловый менеджер" })