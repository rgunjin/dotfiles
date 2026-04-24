-----------------------------------------------------------------
-- Diagnostics --------------------------------------------------
-----------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = false,
  float = {
    border    = "rounded",
    focusable = false,
    max_width  = 80,
    max_height = 20,
    source    = "always",
    header    = "",
    prefix    = "",
  },
  signs          = true,
  underline      = true,
  update_in_insert = false,
})
-----------------------------------------------------------------
-- nvim-cmp -----------------------------------------------------
-----------------------------------------------------------------
local cmp     = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
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
-- Общий on_attach ----------------------------------------------
-----------------------------------------------------------------
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
  end
  map("n", "gd",          vim.lsp.buf.definition)
  map("n", "gr",          vim.lsp.buf.references)
  map("n", "K",           vim.lsp.buf.hover)
  map("n", "<leader>rn",  vim.lsp.buf.rename)
  map("n", "<leader>ca",  vim.lsp.buf.code_action)
  map("n", "<leader>e",   function()
    vim.diagnostic.open_float(nil, { focus = false })
  end)
end
-----------------------------------------------------------------
-- LSP servers (новый API, Neovim 0.11+) -----------------------
-----------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach    = on_attach,
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = { checkThirdParty = false },
    },
  },
})
vim.lsp.config("clangd", {
  on_attach    = on_attach,
  capabilities = capabilities,
})
vim.lsp.config("rust_analyzer", {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo      = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})
vim.lsp.enable({ "lua_ls", "pylsp", "bashls", "clangd", "rust_analyzer", "gopls" })
-----------------------------------------------------------------
-- Clangd commands ----------------------------------------------
-----------------------------------------------------------------
vim.api.nvim_create_user_command('ClangdSwitchSourceHeader', function()
  local params = { uri = vim.uri_from_bufnr(0) }
  vim.lsp.buf_request(0, 'textDocument/switchSourceHeader', params, function(err, result)
    if err then
      vim.notify(tostring(err), vim.log.levels.ERROR)
      return
    end
    if result then
      vim.cmd('e ' .. vim.uri_to_fname(result))
    end
  end)
end, {})
