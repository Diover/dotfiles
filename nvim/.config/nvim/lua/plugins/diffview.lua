return {
	"sindrets/diffview.nvim",
	config = function()
		local actions = require("diffview.actions")

		-- Patch detach_buffer to guard against invalid buffers when restoring files
		local File = require("diffview.vcs.file").File
		local orig_detach = File.detach_buffer
		File.detach_buffer = function(self)
			if self.bufnr and not vim.api.nvim_buf_is_valid(self.bufnr) then
				File.attached[self.bufnr] = nil
				return
			end
			orig_detach(self)
		end

		require("diffview").setup({
			enhanced_diff_hl = false,
			hooks = {
				view_leave = function(view)
					local tabpage = view.tabpage
					if tabpage and vim.api.nvim_tabpage_is_valid(tabpage) then
						for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
							local buf = vim.api.nvim_win_get_buf(win)
							vim.bo[buf].modified = false
						end
					end
				end,
			},
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
