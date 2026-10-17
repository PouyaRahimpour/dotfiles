local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        -- The parsers below match the languages in the previous configuration.
        ensure_installed = { "c", "cpp", "python", "java", "lua", "vim" },
        sync_install = false,
        auto_install = true,

        -- Intentionally preserve your choice not to use Tree-sitter highlighting.
        -- The parsers and folds.scm queries are still used by vim.treesitter.foldexpr().
        highlight = {
            enable = false,
            additional_vim_regex_highlighting = false,
        },
    })
end

return M
