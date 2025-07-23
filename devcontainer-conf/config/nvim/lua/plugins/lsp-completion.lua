return {
  -- ===================================================================
  --  Mason: Установщик языковых серверов
  -- ===================================================================
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- ===================================================================
  -- Lspconfig: Настройщик языковых серверов
  -- ===================================================================
  {
    "neovim/nvim-lspconfig",
    -- Зависимости: mason для установки и mason-lspconfig для связи
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Список серверов, которые нужно автоматически установить и настроить
      local servers = { "lua_ls", "pyright", "tsserver", "gopls", "rust_analyzer", "cssls" }

      -- Настраиваем каждый сервер из списка
      for _, server_name in ipairs(servers) do
        lspconfig[server_name].setup({
          capabilities = capabilities, -- Сообщаем серверу о возможностях нашего клиента
        })
      end

      -- Горячие клавиши, которые будут работать только при активном LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local keymap = vim.keymap
          local opts = { buffer = ev.buf }
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          keymap.set("n", "K", vim.lsp.buf.hover, opts)
          keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },

  -- ===================================================================
  -- Cmp: Движок автодополнения
  -- ===================================================================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- Источник для LSP
      "hrsh7th/cmp-buffer",      -- Источник из слов в текущем буфере
      "hrsh7th/cmp-path",        -- Источник для путей файловой системы
      "L3MON4D3/LuaSnip",        -- Движок сниппетов
      "saadparwaiz1/cmp_luasnip", -- Источник для сниппетов
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        -- Подключаем сниппеты
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        -- Настраиваем горячие клавиши для меню автодополнения
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Принять выбранный вариант
        }),
        -- Указываем источники для автодополнения и их приоритет
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}