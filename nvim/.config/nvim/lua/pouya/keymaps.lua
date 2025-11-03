vim.g.mapleader = " "
vim.g.maplocalleader = " "
local function map(mode, x, y)
    vim.keymap.set(mode, x, y)
end
local maps = {
    {"n", "<leader>e", ":Lex<cr>"},
    {"n", "<leader>q", ":q<cr>"},

    -- motions
    {"n", "<c-h>", "<c-w>h"},
    {"n", "<c-l>", "<c-w>l"},
    {"n", "<c-k>", "<c-w>k"},
    {"n", "<c-j>", "<c-w>j"},

    -- resize splits
    {"n", "<c-up>", ":resize -2<cr>"},
    {"n", "<c-down>", ":resize +2<cr>"},
    {"n", "<c-left>", ":vertical resize -2<cr>"},
    {"n", "<c-right>", ":vertical resize +2<cr>"},

    {{"i", "v", "c"}, "jk", "<esc>"},

    -- move btw tabs?
    {"n", "<s-l>", ":bnext<cr>"},
    {"n", "<s-h>", ":bprevious<cr>"},

    {"v", "J", ":m '>+1<CR>gv=gv"},
    {"v", "K", ":m '<-2<CR>gv=gv"},

    {"v", "p", [["_dP]]},
    {{"n", "v"}, "<leader>y", [["+y]]},

    --{"n", "<leader>3", "<cmd>w<cr><cmd>vert bel term g++ -ggdb -std=c++17 -DLOCAL -O2 %:~ -o %:p:r && %:~:r < %:~:h/inp <CR>"}
}
for i, v in pairs(maps) do
    map(v[1], v[2], v[3])
end

--vim.api.nvim_create_user_command(
    --"Cptmp",
    --"!cat ~/cptmp1.cpp> %",
    --{ nargs = 0}
--)

-------------------- don't know about these things below --------------

--map("n", "J", "mzJ`z")
--map("n", "<C-d>", "<C-d>zz")
--map("n", "<C-u>", "<C-u>zz")
--map("n", "n", "nzzzv")
--map("n", "N", "Nzzzv")

map("n", "<leader>Y", [["+Y]])
map({"n", "v"}, "<leader>d", [["_d]])

--map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--map("n", "<leader>f", vim.lsp.buf.format)

--map("n", "<C-k>", "<cmd>cnext<CR>zz")
--map("n", "<C-j>", "<cmd>cprev<CR>zz")
--map("n", "<leader>k", "<cmd>lnext<CR>zz")
--map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- map("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/pouya/remap.lua<CR>");
-- map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

