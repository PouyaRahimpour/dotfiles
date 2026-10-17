local map = vim.keymap.set

-- General
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
map({ "i", "v", "c" }, "jk", "<Esc>", { desc = "Escape" })
map("n", "<leader>e", "<cmd>Lex<CR>", { desc = "Open netrw file explorer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize splits
map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Editing
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "p", [=["_dP]=], { desc = "Paste without replacing register" })
map({ "n", "v" }, "<leader>d", [=["_d]=], { desc = "Delete without yanking" })

-- System clipboard
map({ "n", "v" }, "<leader>y", [=["+y]=], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [=["+Y]=], { desc = "Yank line to system clipboard" })

-- Substitute the word under the cursor throughout the current buffer.
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
    desc = "Substitute word under cursor",
})
