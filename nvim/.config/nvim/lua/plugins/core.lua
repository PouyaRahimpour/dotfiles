return {
    -- One theme instead of a cycle through multiple themes.
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    -- Neovim 0.11-compatible nvim-treesitter API. The main branch now targets
    -- Neovim 0.12+, while master is frozen for 0.10/0.11 compatibility.
    -- Parsers and fold queries are installed, but highlighting remains disabled
    -- to preserve the behavior of the previous configuration.
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("pouya.treesitter").setup()
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            require("pouya.lsp").setup()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            require("pouya.completion").setup()
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({})
            vim.keymap.set("n", "<leader>t", "<cmd>Telescope find_files<CR>", {
                desc = "Find files",
            })
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
                desc = "Search text in project",
            })
        end,
    },
}
