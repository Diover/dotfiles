return {
	"sindrets/diffview.nvim",
	config = function()
		local actions = require("diffview.actions")

		require("diffview").setup({
			enhanced_diff_hl = false,
			keymaps = {
				view = {
					{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close menu" } },
					{ "n", "tw", "<Cmd>windo set wrap<CR>", { desc = "Turn on word [W]rap" } },
					{ "n", "tn", "<Cmd>windo set nowrap<CR>", { desc = "Turn off word [W]rap" } },
				},
				file_panel = {
					{
						"n",
						"<CR>",
						actions.goto_file_tab,
						{ desc = "Open file in a previous tab page" },
					},
					{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close menu" } },
				},
				file_history_panel = {
					{
						"n",
						"<CR>",
						actions.goto_file_tab,
						{ desc = "Open file in a previous tab page" },
					},
					{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close menu" } },
				},
			},
			view = {
				default = {
					disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
				},
				merge_tool = {
					-- Config for conflicted files in diff views during a merge or rebase.
					layout = "diff3_mixed",
				},
			},
			file_panel = {
				listing_style = "list",
				win_config = {
					position = "bottom",
					height = 18,
				},
			},
		})
	end,
}
