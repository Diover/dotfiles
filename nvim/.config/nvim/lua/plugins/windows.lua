return {
	"anuvyklack/windows.nvim",
	dependencies = { "anuvyklack/middleclass" },
	config = function()
		require("windows").setup()
		local function cmd(command)
			return table.concat({ "<Cmd>", command, "<CR>" })
		end

		vim.keymap.set("n", "<leader>w<CR>", cmd("WindowsMaximize"))
		vim.keymap.set("n", "<leader>w_", cmd("WindowsMaximizeVertically"))
		vim.keymap.set("n", "<leader>w|", cmd("WindowsMaximizeHorizontally"))
		vim.keymap.set("n", "<leader>w=", cmd("WindowsEqualize"))

		vim.keymap.set(
			"n",
			"<leader>w]",
			cmd(":vertical resize " .. vim.opt.columns:get() * 0.8),
			{ desc = "[W]indow horizontal size increase (80%)" }
		)
		vim.keymap.set(
			"n",
			"<leader>w[",
			cmd(":vertical resize " .. vim.opt.columns:get() * 0.2),
			{ desc = "[W]indow horizontal size decrease (20%)" }
		)
	end,
}
