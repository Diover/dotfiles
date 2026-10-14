return {
	"Mathijs-Bakker/godotdev.nvim",
	dependencies = { "nvim-dap", "nvim-treesitter" },

	config = function()
		require("godotdev").setup({
			godot_path = "/Users/ssmirnov/.local/bin/godot-wrapper.sh",

			treesitter = {
				auto_setup = false,
			},
			run = {
				console = {
					enabled = true,
				},
			},
		})
	end,
}
