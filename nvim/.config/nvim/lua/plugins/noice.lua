-- default LazyVim plugin
-- this config just adds borders to lsp hover (K)
return {
	"folke/noice.nvim",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	opts = {
		commands = {
			last = {
				opts = { border = "single" },
			},
		},
		presets = {
			long_message_to_split = true,
			lsp_doc_border = true,
		},
		views = {
			mini = {
				win_options = {
					winblend = 100,
				},
			},
		},
		lsp = {
			documentation = {
				opts = {
					win_options = { wrap = true },
				},
			},
		},
		routes = {
			{ filter = { find = "E162" }, view = "mini" },
			{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
			{ filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
			{ filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
			{ filter = { event = "emsg", find = "E23" }, skip = true },
			{ filter = { event = "emsg", find = "E20" }, skip = true },
			{ filter = { find = "No signature help" }, skip = true },
			{ filter = { find = "E37" }, skip = true },
		},
	},
}
