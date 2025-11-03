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




    --------------- no need to set because it's default ---------------
    -- vim.opt.hlsearch = true
    -- vim.opt.incsearch = true -- incremental search



    --------------- don't know what are these things below :/ ------------
    -- vim.opt.isfname:append("@-@")
    updatetime = 500,
    termguicolors = true,
    --vim.opt.swapfile = false
    --vim.opt.backup = false
    undodir = os.getenv("HOME") .. "/.vim/undodir",
    undofile = true
}
for k, v in pairs(options) do
    vim.opt[k] = v
end

