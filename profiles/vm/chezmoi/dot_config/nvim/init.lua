require("vim._core.ui2").enable({})

vim.g.loaded_python3_provider = 0
vim.g.mapleader = " "
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.shortmess:append("c")
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

require("config.plugins")
require("config.treesitter-parsers")
require("config.mason")
require("config.format")
require("config.snacks")
require("config.lsp")
require("config.keymaps")

vim.cmd.colorscheme("catppuccin-mocha")
require("trouble").setup()
require("gitsigns").setup()
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})
