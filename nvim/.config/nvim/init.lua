-- Keep leader keys defined before lazy.nvim loads.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("pouya.options")
require("pouya.keymaps")
require("pouya.lazy")
