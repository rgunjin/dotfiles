require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'cpea2506/one_monokai.nvim'
    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function ()
            require'alpha'.setup(require'alpha.themes.startify'.opts)
            local startify = require("alpha.themes.startify")
            startify.section.mru_cwd.val = { { type = "padding", val = 0 } }
            startify.section.bottom_buttons.val = {
                startify.button("v", "neovim config", ":e ~/.config/nvim/init.lua<cr>"),
                startify.button("q", "quit nvim", ":qa<cr>"),
            }
            vim.api.nvim_set_keymap('n', '<c-n>', ":Alpha<cr>", { noremap = true });
        end
    }
    use 'voldikss/vim-floaterm'

    -- IDE
    use 'nvim-treesitter/nvim-treesitter'
    use {'neoclide/coc.nvim', branch = 'release'}
--    use 'neovim/nvim-lspconfig'
--    use 'williamboman/nvim-lsp-installer'
--    use 'hrsh7th/cmp-nvim-lsp'
--    use 'hrsh7th/cmp-buffer'
--    use 'hrsh7th/cmp-path'
--    use 'hrsh7th/cmp-cmdline'
--    use 'hrsh7th/nvim-cmp'
end)

require("one_monokai").setup({
    transparent = true
})
