local M = {}

function M.setup()
    -- nvim-lspconfig supplies clangd's defaults; Neovim 0.11+ owns activation.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("clangd", { capabilities = capabilities })
    vim.lsp.enable("clangd")

    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = "rounded",
            source = true,
        },
    })

    local group = vim.api.nvim_create_augroup("PouyaLspKeymaps", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(event)
            local opts = { buffer = event.buf, silent = true }
            local map = vim.keymap.set

            map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, {
                desc = "LSP hover",
            }))
            map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, {
                desc = "Go to definition",
            }))
            map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {
                desc = "Go to declaration",
            }))
            map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, {
                desc = "Find references",
            }))
            map("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {
                desc = "Rename symbol",
            }))
            map("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {
                desc = "Code action",
            }))
            map("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, {
                desc = "Show diagnostic details",
            }))
            map("n", "<leader>lf", function()
                vim.lsp.buf.format({ async = true })
            end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        end,
    })
end

return M
