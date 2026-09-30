return {
	"sudo-tee/opencode.nvim",
	branch = "v2", -- Use the v2 branch for testing with OpenCode v2
	config = function()
		require("opencode").setup({
			keymap_prefix = "<leader>i", -- Default keymap prefix for global keymaps
		})
	end,
	dependencies = {
		"MeanderingProgrammer/render-markdown.nvim",

		-- Optional, for file mentions and commands completion, pick only one
		"saghen/blink.cmp",

		-- Optional, for file mentions picker, pick only one
		"nvim-telescope/telescope.nvim",
	},
}
