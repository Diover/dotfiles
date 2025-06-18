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
			-- All the info you're looking for is in `:help telescope.setup()`

			pickers = {
				find_files = {
					hidden = true,
				},
			},

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
				file_ignore_patterns = { "^.git/" },

				-- Needed by live_grep_args
				vimgrep_arguments = {
					-- Defaults
					-- all required except `--smart-case`
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",

					-- additional options
					"--hidden",
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					mappings = { -- extend mappings
						i = {
							-- More information about ripgrep flags:
							-- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
							["<C-k>"] = lga_actions.quote_prompt(),
							-- Case-insensitive glob. Later globs override previous ones.
							-- Examples: --glob **/plugin/**/*.lua, --glob !*.toml
							["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							["<C-t>"] = lga_actions.quote_prompt({ postfix = " --type " }), -- Type aliases are used (see rg --type-list). The "all" type is used to cover all available types.
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --no-ignore" }),
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
		local live_grep_args = require("telescope").extensions.live_grep_args
		local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>si", builtin.builtin, { desc = "[S]earch bu[I]lt-in Telescope" })
		vim.keymap.set(
			"n",
			"<leader>sw",
			live_grep_args_shortcuts.grep_word_under_cursor,
			{ desc = "[S]earch current [W]ord" }
		)
		vim.keymap.set(
			"v",
			"<leader>sw",
			live_grep_args_shortcuts.grep_visual_selection,
			{ desc = "[S]earch current [W]ord (visual selection)" }
		)
		vim.keymap.set("n", "<leader><leader>", live_grep_args.live_grep_args, { desc = "[ ] Search by live grep" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })

		-- Git searches
		vim.keymap.set("n", "<leader>sgf", builtin.git_files, { desc = "[S]earch [G]it [F]iles" })
		vim.keymap.set("n", "<leader>sgs", builtin.git_status, { desc = "[S]earch [G]it [S]tatus" })
		vim.keymap.set("n", "<leader>sgc", builtin.git_commits, { desc = "[S]earch [G]it [C]ommits" })
		vim.keymap.set("n", "<leader>sgb", builtin.git_branches, { desc = "[S]earch [G]it [B]ranches" })
		vim.keymap.set(
			"n",
			"<leader>sgu",
			builtin.git_bcommits,
			{ desc = "[S]earch [G]it commits for current b[U]ffer" }
		)
		vim.keymap.set(
			"v",
			"<leader>sgu",
			builtin.git_bcommits_range,
			{ desc = "[S]earch [G]it commits for current line selection in current b[U]ffer" }
		)

		-- Diagnostics and notifications
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>st", "<Cmd>Telescope notify<CR>", { desc = "[S]earch no[T]ification messages" })

		-- Resume and misc
		vim.keymap.set("n", "<leader>s.", builtin.resume, { desc = "[S]earch resume ('.' for repeat)" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch existing [B]uffers" })

		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })
	end,
}
