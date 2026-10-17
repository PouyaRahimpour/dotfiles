
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd("packer.nvim")
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end,
    },
}
return packer.startup(function(use)
    use({'wbthomason/packer.nvim'})
    ------------- toggleterm ---------------
    use("akinsho/toggleterm.nvim")

    ------------- telescope -----------------
    use({
        'nvim-telescope/telescope.nvim',
        requires = { 
            {'nvim-lua/plenary.nvim'},
            {"BurntSushi/ripgrep"},
            {"sharkdp/fd"}
        }
    })

    ------------ colorschemes ----------------
    use({ "ellisonleao/gruvbox.nvim" })
    use({ "doums/darcula" })
    --use({
        --"loctvl842/monokai-pro.nvim",
        --config = function()
            --require("monokai-pro").setup()
        --end
    --})

    --use({
        --'morhetz/gruvbox',
        --config = function()
            --vim.cmd.colorscheme("gruvbox")
        --end
    --})

    --use({
        --'rose-pine/neovim',
        --as = 'rose-pine',
    --})
    use({
        'RRethy/nvim-base16',
        as ='base16-colors',
    })
    use({
        'xiyaowong/transparent.nvim',
        as = 'transparent'
    })

    ------------- treesitter --------------------
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    use('nvim-treesitter/playground')

    -------------- harpoon ----------------------
    use('theprimeagen/harpoon')

    -------------- undotree ---------------------
    use('mbbill/undotree')

    --------------- fugitive --------------------
    use('tpope/vim-fugitive')

    ------------------ LSP ----------------------
    -- Autocompletion
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'saadparwaiz1/cmp_luasnip'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-nvim-lua'}

    -- Snippets
    use {'L3MON4D3/LuaSnip'}

    -------------------- syntax check --------------------
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"

    ---------------- vimtex --------------------
    use "lervag/vimtex"

    -------------------- cp --------------------
    use {
        'xeluxee/competitest.nvim',
        requires = 'MunifTanjim/nui.nvim',
        config = function() require('competitest').setup() end
    }


end)
