require("snacks").setup({
	picker = {
		enabled = true,
		win = {
			input = {
				keys = {
					["<Tab>"] = { "focus_list", mode = { "i", "n" } },
					["<S-Tab>"] = { "focus_list", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<Tab>"] = "list_down",
					["<S-Tab>"] = "list_up",
				},
			},
		},
	},
	statuscolumn = {
		enabled = true,
	},
})
