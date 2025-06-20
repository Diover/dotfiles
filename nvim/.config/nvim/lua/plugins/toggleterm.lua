return {
	{
		"akinsho/nvim-toggleterm.lua",
		config = function()
			require("toggleterm").setup({
				direction = "tab",
				highlights = { FloatBorder = { link = "FloatBorder" } },
				open_mapping = [[<c-\>]],
				on_create = function(term)
					local opts = { buffer = term.bufnr }
					vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
				end,
				shading_factor = -20,
			})
		end,
	},
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		dependencies = {
			"akinsho/nvim-toggleterm.lua",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
		},
		config = true,
	},
}
