return {
	"Morozzzko/git_browse.nvim",
	config = function()
		local git_browse = require("git_browse")
		git_browse.setup({
			git_branch_command = function()
				return shell_exec(
					'git branch --format "%(refname:short):%(push:short):%(upstream:short):%(objecttype):%(HEAD)"'
				)
			end,
		})

		vim.keymap.set(
			{ "n" },
			"<leader>gee",
			git_browse.browse_line,
			{ noremap = true, silent = true, desc = "[G]it Browse: [E]xplore Line" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>geb",
			git_browse.blame_line,
			{ noremap = true, silent = true, desc = "[G]it Browse: [E]xplore and [B]lame Line" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>gef",
			git_browse.browse,
			{ noremap = true, silent = true, desc = "[G]it Browse: [E]xplore [F]ile" }
		)
		vim.keymap.set(
			{ "v" },
			"<leader>ges",
			git_browse.browse_selected,
			{ noremap = true, silent = true, desc = "[G]it Browse: [E]xplore [S]elected" }
		)
		vim.keymap.set(
			{ "v" },
			"<leader>gebs",
			git_browse.blame_selected,
			{ noremap = true, silent = true, desc = "[G]it Browse: [E]xplore and [B]lame [S]elected" }
		)
	end,
}
