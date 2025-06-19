return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		config = function()
			---@module 'render-markdown'
			---@type render.md.UserConfig
			local opts = {
				completions = { lsp = { enabled = true } },
				-- completions = { blink = { enabled = true } },
			}

			require("render-markdown").setup(opts)
		end,
	},
}
