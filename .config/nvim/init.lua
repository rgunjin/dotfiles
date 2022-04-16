require('config')
require('maps')
require('packages')

local configs = require'nvim-treesitter.configs'
configs.setup {
    ensure_installed = { "c", "cpp", "lua", "cmake", "bash" }, -- Only use parsers that are maintained
    highlight = {
        enable = true, -- enable highlighting
    },
    indent = {
        enable = false, -- default is disabled anyways
    }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

--local lsp_installer = require("nvim-lsp-installer")
--lsp_installer.on_server_ready(function(server)
--    local opts = {}
--    if server.name == "sumneko_lua" then
--        opts = {
--            settings = {
--                Lua = {
--                    diagnostics = {
--                        globals = { 'vim', 'use' }
--                    },
--                }
--            }
--        }
--    end
--    server:setup(opts)
--end)
--
--  -- Setup nvim-cmp.
--  local cmp = require'cmp'
--  cmp.setup({
--    mapping = cmp.mapping.preset.insert({
--      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--      ['<C-f>'] = cmp.mapping.scroll_docs(4),
--      ['<C-Space>'] = cmp.mapping.complete(),
--      ['<C-e>'] = cmp.mapping.abort(),
--      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--    }),
--    sources = cmp.config.sources({
--      { name = 'nvim_lsp' },
--      { name = 'vsnip' }, -- For vsnip users.
--    }, {
--      { name = 'buffer' },
--    })
--  })
--
--  -- Set configuration for specific filetype.
--  cmp.setup.filetype('gitcommit', {
--    sources = cmp.config.sources({
--      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--    }, {
--      { name = 'buffer' },
--    })
--  })
--
--  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
--  cmp.setup.cmdline('/', {
--    mapping = cmp.mapping.preset.cmdline(),
--    sources = {
--      { name = 'buffer' }
--    }
--  })
--
--  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--  cmp.setup.cmdline(':', {
--    mapping = cmp.mapping.preset.cmdline(),
--    sources = cmp.config.sources({
--      { name = 'path' }
--    }, {
--      { name = 'cmdline' }
--    })
--  })
--
--  -- Setup lspconfig.
--  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--  require('lspconfig')['sumneko_lua'].setup {
--    capabilities = capabilities
--  }
--  require('lspconfig')['ccls'].setup {
--    capabilities = capabilities
--  }
--  require('lspconfig')['cmake'].setup {
--    capabilities = capabilities
--  }
--  require('lspconfig')['bashls'].setup {
--    capabilities = capabilities
--  }
