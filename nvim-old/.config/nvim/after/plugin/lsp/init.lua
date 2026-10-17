-- for later (more advanced setup)
--local stat_ok, _ = pcall(require, "lspconfig")
--if not stat_ok then
   --return
--end
--require("lsp.handlers").setup()
--require("lsp.lsp").setup()

-- Modern LSP setup (Neovim 0.11+)
local lsp = vim.lsp

-- Define clangd configuration directly
local clangd_config = {
  name = "clangd",
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = function(fname)
    return vim.fs.root(fname, { ".git", ".clangd", "compile_commands.json", "compile_flags.txt" }) or vim.fn.getcwd()
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

-- Automatically start clangd when opening relevant filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    if vim.fn.executable("clangd") == 1 then
      lsp.start(clangd_config)
    else
      vim.notify("clangd not found in PATH", vim.log.levels.ERROR)
    end
  end,
})

