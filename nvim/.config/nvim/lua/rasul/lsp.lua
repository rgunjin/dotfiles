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
local lspconfig = require("lspconfig")

-- 🔹 Lua --------------------------------------------------------
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = { checkThirdParty = false },
    },
  },
})

-- 🔹 Python -----------------------------------------------------
lspconfig.pyright.setup({
  capabilities = capabilities,
})

-- 🔹 Bash -------------------------------------------------------
lspconfig.bashls.setup({
  capabilities = capabilities,
})

-- 🔹 C / C++ ----------------------------------------------------
lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd", "--offset-encoding=utf-16" },
})

-- 🔹 Rust -------------------------------------------------------
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

-- 🔹 Go ---------------------------------------------------------
lspconfig.gopls.setup({
  capabilities = capabilities,
})

