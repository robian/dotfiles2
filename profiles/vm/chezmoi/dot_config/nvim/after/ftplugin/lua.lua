pcall(vim.treesitter.start)

if vim.g.config_lua_lsp then
	return
end

vim.g.config_lua_lsp = true

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.lsp.enable("lua_ls")
