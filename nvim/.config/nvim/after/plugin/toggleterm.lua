local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<leader>;]],
    close_mapping = [[<leader>;]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,

	start_in_insert = false,
	insert_mappings = true,
    terminal_mappings = true,
    auto_scroll = false, -- scrolls down when close and open

	persist_size = true,
	direction = "float", -- you can set to vertical or horizantal also
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

-------------- for CP ---------------
--vim.keymap.set({"n", "v"}, "<leader>3", ":w<cr>:TermExec cmd='g++ -ggdb -std=c++20 -DDEBUG -O2 %:~ -o %:p:r && %:~:r < %:~:h/inp'<cr>")
vim.keymap.set({"n", "v"}, "<leader>4", ":TermExec cmd='python3 -m IPython'<cr>")

-- ecnerwala's flags
--CXXFLAGS = "-std=c++20 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion"
--DEBUG_CXXFLAGS1 = "-fsanitize=address -fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize-recover=all -fstack-protector-all -D_FORTIFY_SOURCE=2"
--DEBUG_CXXFLAGS2 = "-D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC"

local CPLIB = os.getenv("HOME").."/dev/cp/lib"
local CXXFLAGS = table.concat({
    "-std=c++20",
    "-O2",
    "-Wall",
    "-Wextra",
--  "-Wpedantic",
    "-Wshadow",
    "-Wformat=2",
    "-Wfloat-equal",
    "-Wconversion",
    "-Wlogical-op",
    "-Wshift-overflow=2",
    "-Wduplicated-cond",
    "-Wcast-qual",
    "-Wcast-align",
    "-Wno-unused-result",
    "-Wno-sign-conversion",
    "-I" .. CPLIB,
}, " ")
local DEBUG_CXXFLAGS = table.concat({
    "-D_GLIBCXX_DEBUG",
    "-D_GLIBCXX_DEBUG_PEDANTIC",
}, " ")
vim.keymap.set({"n", "v"}, "<leader>3",
    ":w<cr>"
    ..":! python3 "..CPLIB.."/expander.py --lib "..CPLIB.." %:~<cr>"
    ..":TermExec cmd='g++ -ggdb -DLOCAL "
    .. CXXFLAGS .. " "
    .. DEBUG_CXXFLAGS
    .. " %:~ -o %:p:r && %:~:r < %:~:h/inp'<cr>"
)
-------------------------------------

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal


local cp = Terminal:new({ cmd = "g++ --version", hidden = true})
function _CP_TOGGLE()
    cp:toggle()
end


--local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
--function _LAZYGIT_TOGGLE()
	--lazygit:toggle()
--end


--local node = Terminal:new({ cmd = "node", hidden = true })
--function _NODE_TOGGLE()
	--node:toggle()
--end

