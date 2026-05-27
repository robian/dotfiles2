local treesitter_parsers = {
	"bash",
	"rust",
	"python",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"css",
	"html",
}

local ts = require("nvim-treesitter")

ts.setup()

local installed = ts.get_installed("parsers")
local missing = vim.tbl_filter(function(parser)
	return not vim.tbl_contains(installed, parser)
end, treesitter_parsers)

if #missing > 0 then
	ts.install(missing, { summary = true })
end

local unwanted = vim.tbl_filter(function(parser)
	return not vim.tbl_contains(treesitter_parsers, parser)
end, installed)

if #unwanted > 0 then
	ts.uninstall(unwanted)
end
