local plugins = {
	{
		src = "https://github.com/folke/snacks.nvim",
	},
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
	},
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
	},
	{
		src = "https://github.com/neovim/nvim-lspconfig",
	},
	{
		src = "https://github.com/stevearc/conform.nvim",
	},
	{
		src = "https://github.com/folke/trouble.nvim",
	},
	{
		src = "https://github.com/mason-org/mason.nvim",
	},
	{
		src = "https://github.com/saghen/blink.cmp",
		version = "v1",
	},
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		version = vim.version.range("^9"),
	},
}

vim.pack.add(plugins, { confirm = false })

local undeclared = {}
for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
	if not plugin.active then
		table.insert(undeclared, plugin.spec.name)
	end
end

if #undeclared > 0 then
	vim.pack.del(undeclared)
end
