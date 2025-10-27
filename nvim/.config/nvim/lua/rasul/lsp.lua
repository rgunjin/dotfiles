-----------------------------------------------------------------
-- Mason --------------------------------------------------------
-----------------------------------------------------------------
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pylsp",
    "bashls",
    "clangd",          -- C / C++
    "rust_analyzer",   -- Rust
    "gopls",
  },
  automatic_installation = true,
})

-----------------------------------------------------------------
-- nvim-cmp (completion) ---------------------------------------
-----------------------------------------------------------------
local cmp     = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"]   = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"]    = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip"  },
    { name = "buffer"   },
  },
})


-----------------------------------------------------------------
-- LSP servers --------------------------------------------------
-----------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 🔹 Lua --------------------------------------------------------
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = { checkThirdParty = false },
    },
  },
})

-- 🔹 Python -----------------------------------------------------
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

-- 🔹 Bash -------------------------------------------------------
vim.lsp.config("bashls", {
  capabilities = capabilities,
})

-- 🔹 C / C++ ----------------------------------------------------
vim.lsp.config("clangd", {
  capabilities = capabilities,
  cmd = { "clangd", "--offset-encoding=utf-16" }, -- корректный offset для cmp
})

-- 🔹 Rust -------------------------------------------------------
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

-- 🔹 Go ---------------------------------------------------------
vim.lsp.config("gopls", {
    capabilities = capabilities,
})
