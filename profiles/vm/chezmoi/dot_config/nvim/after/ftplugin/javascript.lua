pcall(vim.treesitter.start)

if vim.g.config_typescript_lsp then
	return
end

vim.g.config_typescript_lsp = true

vim.lsp.config("vtsls", {})
vim.lsp.config("tailwindcss", {})
vim.lsp.config("biome", {})
vim.lsp.enable({ "vtsls", "tailwindcss", "biome" })
