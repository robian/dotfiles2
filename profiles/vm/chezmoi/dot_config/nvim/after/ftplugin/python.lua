pcall(vim.treesitter.start)

if vim.g.config_python_lsp then
	return
end

vim.g.config_python_lsp = true
vim.lsp.config("pyright", {})
vim.lsp.enable("pyright")
