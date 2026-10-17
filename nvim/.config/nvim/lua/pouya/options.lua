local opt = vim.opt

-- Display
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Editing and movement
opt.wrap = false
opt.scrolloff = 8
opt.timeoutlen = 200
opt.updatetime = 500

-- Preserve the original folding behavior. The compatible nvim-treesitter
-- master branch supplies the parsers and fold queries used by Neovim 0.11.
-- Highlighting remains disabled; folding is independent of highlighting.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = true
opt.foldlevel = 99
opt.foldtext = ""
opt.fillchars = { fold = " " }

-- Persistent undo, kept inside Neovim's state directory.
opt.undofile = true
local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
opt.undodir = undo_dir

-- nvim-cmp uses this completion menu behavior.
opt.completeopt = { "menu", "menuone", "noselect" }
