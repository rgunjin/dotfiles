return {
  ---------------------------------------------------------------------------
  -- Treesitter -------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    event  = { "BufReadPost", "BufNewFile" },
    config = function() require("rasul.config.treesitter") end,
  },

  ---------------------------------------------------------------------------
  -- Telescope --------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    version      = "0.1.*",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd          = "Telescope",
    config       = function() require("rasul.config.telescope") end,
  },

  ----------------------------------------------------------------------------
  -- Harpoon 2 ---------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",          -- ветка со второй версией
    event  = "VeryLazy",
    config = function() require("rasul.config.harpoon") end,
  },

  ---------------------------------------------------------------------------
  -- Rose-Pine --------------------------------------------------------------
  {
    "rose-pine/neovim",
    name     = "rose-pine",
    priority = 1000,
    config   = function() require("rasul.config.theme") end,
  },

  ----------------------------------------------------------------------------
  -- Git ---------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event  = "BufReadPre",
    config = function() require("rasul.config.gitsigns") end,
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },

  ---------------------------------------------------------------------------
  -- Undotree ---------------------------------------------------------------
  { "mbbill/undotree", cmd = "UndotreeToggle" },

  ---------------------------------------------------------------------------
  -- LSP / completion stack -------------------------------------------------
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
}
