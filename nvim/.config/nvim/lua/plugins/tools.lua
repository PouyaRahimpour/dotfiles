return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
        end,
    },

    {
        "theprimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- Harpoon v1 API, matching the configuration already in use.
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: add file" })
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon: menu" })
            vim.keymap.set("n", "<C-s>", function() ui.nav_file(1) end, { desc = "Harpoon: file 1" })
            vim.keymap.set("n", "<C-i>", function() ui.nav_file(2) end, { desc = "Harpoon: file 2" })
            vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end, { desc = "Harpoon: file 3" })
            vim.keymap.set("n", "<C-t>", function() ui.nav_file(4) end, { desc = "Harpoon: file 4" })
        end,
    },

    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", {
                desc = "Toggle undo tree",
            })
        end,
    },

    {
        "lervag/vimtex",
        ft = { "tex" },
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.tex_conceal = "abdmg"
            vim.g.vimtex_compiler_method = "latexmk"
        end,
    },
}
