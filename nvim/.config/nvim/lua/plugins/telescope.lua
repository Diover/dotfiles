return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{
			"nvim-tree/nvim-web-devicons",
			enabled = vim.g.have_nerd_font,
		},
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = { signs = false },
		},
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.1.0",
		},
	},
	config = function()
		local lga_actions = require("telescope-live-grep-args.actions")
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`

			defaults = {
				path_display = { shorten = { len = 2, exclude = { 1, -1, -2, -3 } } },
				-- path_display = { "filename_first" },
				-- path_display = { "smart" },
				dynamic_preview_title = true,
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				["live_grep_args"] = {
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					mappings = { -- extend mappings
						i = {
							-- More information about ripgrep flags:
							-- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							-- freeze the current list and start a fuzzy search in the frozen list
							["<C-space>"] = lga_actions.to_fuzzy_refine,
						},
					},
				},
			},
		})
		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "live_grep_args")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set(
			"n",
			"<leader>sg",
			":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			{ desc = "[S]earch by [G]rep" }
		)
		vim.keymap.set("n", "<leader>sf", function()
			builtin.find_files({ hidden = true })
		end, { desc = "[S]earch [F]iles" })
		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		vim.keymap.set("n", "<leader>si", builtin.git_files, { desc = "[S]earch g[I]t files" })
		vim.keymap.set("n", "<leader>sc", builtin.git_commits, { desc = "[S]earch git [C]ommits" })
		vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "[S]earch git [B]ranches" })
		vim.keymap.set("n", "<leader>su", builtin.git_bcommits, { desc = "[S]earch git commits for current b[U]ffer" })
		vim.keymap.set(
			"v",
			"<leader>su",
			builtin.git_bcommits_range,
			{ desc = "[S]earch git commits for current line selection in current b[U]ffer" }
		)

		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>st", "<Cmd>Telescope notify<CR>", { desc = "[S]earch no[T]ification messages" })

		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })
	end,
}
