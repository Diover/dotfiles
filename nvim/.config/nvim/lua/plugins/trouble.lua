return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "[D]iagnostics (workspace)",
		},
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
			desc = "Diagnostics (buffer)",
		},
		{
			"<leader>xs",
			"<cmd>Trouble symbols toggle focus=true win.position=left<cr>",
			desc = "[S]ymbols",
		},
		{
			"<leader>xl",
			"<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
			desc = "[L]SP definitions/references",
		},
		{
			"<leader>xf",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location list ([F]ile)",
		},
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "[Q]uickfix list",
		},
	},
}
