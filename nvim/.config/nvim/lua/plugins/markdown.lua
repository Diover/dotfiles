return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
		config = function()
			---@module 'render-markdown'
			---@type render.md.UserConfig
			local opts = {
				completions = { lsp = { enabled = true } },
				latex = { enabled = false },
				anti_conceal = { enabled = false },
				file_types = { "markdown", "opencode_output" },
				-- completions = { blink = { enabled = true } },
			}

			require("render-markdown").setup(opts)
		end,
	},
}
