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
	local ok, err = pcall(ts.install, missing, { summary = true })
	if not ok then
		vim.schedule(function()
			vim.notify(("treesitter: failed to install parsers: %s"):format(err), vim.log.levels.WARN)
		end)
	end
end
