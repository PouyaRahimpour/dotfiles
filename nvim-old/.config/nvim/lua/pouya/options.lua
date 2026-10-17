local options = {
    nu = true,
    relativenumber = true,

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,
    wrap = false,

    scrolloff = 8, --set margin for vert scroll
    --vim.opt.colorcolumn = "80"
    timeoutlen = 200,

    -- folding
    foldmethod = "expr",
    foldexpr = "v:lua.vim.treesitter.foldexpr()",
    foldenable = true,
    foldlevel = 99,
    -- foldcolumn = "2",
    foldtext = "",
    fillchars = {
        fold = " ",
    },
    --------------- don't know what are these things below :/ ------------
    -- vim.opt.isfname:append("@-@")
    updatetime = 500,
    termguicolors = true,
    --vim.opt.swapfile = false
    --vim.opt.backup = false
    undofile = true,
    undodir = os.getenv("HOME") .. "/.vim/undodir",

}

for k, v in pairs(options) do
    vim.opt[k] = v
end

