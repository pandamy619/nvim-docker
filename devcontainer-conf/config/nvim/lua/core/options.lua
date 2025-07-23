local opt = vim.opt -- для краткости

-- 📜 Нумерация строк
opt.relativenumber = true -- Относительная нумерация
opt.number = true         -- Показывать номер текущей строки

-- ⌨️ Отступы
opt.tabstop = 2       -- Размер табуляции в пробелах
opt.shiftwidth = 2    -- Размер отступа для автоформатирования
opt.expandtab = true  -- Использовать пробелы вместо табов
opt.autoindent = true -- Автоматически выравнивать отступы

-- 🧠 Умный поиск
opt.ignorecase = true -- Игнорировать регистр при поиске
opt.smartcase = true  -- Но учитывать регистр, если в запросе есть заглавные буквы

-- 🎨 Внешний вид
opt.termguicolors = true -- Включить "true color" для тем
opt.wrap = false         -- Отключить перенос строк

-- 💨 Разное
opt.cursorline = true -- Подсвечивать текущую строку
opt.undofile = true   -- Сохранять историю изменений между сессиями