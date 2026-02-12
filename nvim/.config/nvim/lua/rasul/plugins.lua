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
    version = "0.1.*",
    dependencies = { "nvim-lua/plenary.nvim" },
    --lazy = false,
    event = "BufReadPost",
    keys = {
      { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Telescope: find files" },
      { "<C-p>",      function() require("telescope.builtin").git_files()  end, desc = "Telescope: git files" },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Telescope: grep string"
      },
    },
    config = function()
      require("rasul.config.telescope") -- только setup
    end,
  },

  ----------------------------------------------------------------------------
  -- Harpoon 2 ---------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    --lazy = false,
    event = "BufReadPost",
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():append()
        end,
        desc = "Harpoon: add file",
      },
      {
        "<leader>hm",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon: menu",
      },
    },
    config = function()
      require("rasul.config.harpoon") -- только setup
    end,
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
  ---------------------------------------------------------------------------

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pylsp",
        "bashls",
        "clangd",
        "rust_analyzer",
        "gopls",
      },
      automatic_installation = true,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
}
