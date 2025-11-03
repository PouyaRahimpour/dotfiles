-- for later (more advanced setup)
--local stat_ok, _ = pcall(require, "lspconfig")
--if not stat_ok then
   --return
--end
--require("lsp.handlers").setup()
--require("lsp.lsp").setup()

-- Basic LSP setup
local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
  cmd = { "clangd" }, -- ensure it's in PATH
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
}

