--  " This is necessary for VimTeX to load properly. The "indent" is optional.
--  " Note that most plugin managers will do this automatically.
-- filetype plugin indent on


--  " This enables Vim's and neovim's syntax-related features. Without this, some
--  " VimTeX features will not work (see ":help vimtex-requirements" for more
--  " info).
--  syntax enable
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = 'abdmg'
vim.g.vimtex_compiler_method = 'latexmk'
