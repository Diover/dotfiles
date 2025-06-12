return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		{
			"sindrets/diffview.nvim",
			opts = {
				enhanced_diff_hl = false,
				keymaps = {
					view = {
						{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close menu" } },
						{ "n", "tw", "<Cmd>windo set wrap<CR>", { desc = "Turn on word [W]rap" } },
						{ "n", "tn", "<Cmd>windo set nowrap<CR>", { desc = "Turn off word [W]rap" } },
					},
					file_panel = {
						{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close menu" } },
					},
					file_history_panel = {
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
			},
		},
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("neogit").setup({
			-- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
			-- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
			-- normal mode.
			disable_insert_on_commit = true,
			-- "ascii"   is the graph the git CLI generates
			-- "unicode" is the graph like https://github.com/rbong/vim-flog
			-- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
			graph_style = "unicode",
			-- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
			-- sorter instead. By default, this function returns `nil`.
			-- telescope_sorter = function()
			--     return require("telescope").extensions.fzf.native_fzf_sorter()
			-- end,
		})

		vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>")
		vim.keymap.set("n", "<leader>gd", function()
			if next(require("diffview.lib").views) == nil then
				vim.cmd("DiffviewOpen")
			else
				vim.cmd("DiffviewClose")
			end
		end)
		vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>")
		vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<CR>")
		vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<CR>")
		vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<CR>")
	end,
}
