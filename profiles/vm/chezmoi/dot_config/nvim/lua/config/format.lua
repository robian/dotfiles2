require("conform").setup({
	formatters_by_ft = {
		css = { "biome" },
		html = { "biome" },
		javascript = { "biome" },
		javascriptreact = { "biome" },
		json = { "biome" },
		lua = { "stylua" },
		python = { "ruff_format" },
		typescript = { "biome" },
		typescriptreact = { "biome" },
	},
	format_on_save = {
		timeout_ms = 3000,
		lsp_format = "fallback",
	},
})
