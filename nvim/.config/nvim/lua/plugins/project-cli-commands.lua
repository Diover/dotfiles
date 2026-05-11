return {
	"dimaportenko/project-cli-commands.nvim",

	dependencies = {
		"akinsho/nvim-toggleterm.lua",
		"nvim-telescope/telescope.nvim",
	},

	-- optional keymap config
	config = function()
		local OpenActions = require("project_cli_commands.open_actions")
		local RunActions = require("project_cli_commands.actions")

		local config = {
			-- Optional: override the global config path
			-- Default: vim.fn.stdpath('config') .. '/project-cli-commands.config.json'
			-- global_config_path = vim.fn.stdpath('config') .. '/project-cli-commands.config.json',

			-- Key mappings bound inside the telescope window
			running_telescope_mapping = {
				["<C-c>"] = RunActions.exit_terminal,
				["<C-f>"] = RunActions.open_float,
				["<C-v>"] = RunActions.open_vertical,
				["<C-h>"] = RunActions.open_horizontal,
			},
			open_telescope_mapping = {
				{ mode = "i", key = "<CR>", action = OpenActions.execute_script_vertical },
				{ mode = "n", key = "<CR>", action = OpenActions.execute_script_vertical },
				{ mode = "i", key = "<C-h>", action = OpenActions.execute_script },
				{ mode = "n", key = "<C-h>", action = OpenActions.execute_script },
				{ mode = "i", key = "<C-i>", action = OpenActions.execute_script_with_input },
				{ mode = "n", key = "<C-i>", action = OpenActions.execute_script_with_input },
				{ mode = "i", key = "<C-c>", action = OpenActions.copy_command_clipboard },
				{ mode = "n", key = "<C-c>", action = OpenActions.copy_command_clipboard },
				{ mode = "i", key = "<C-f>", action = OpenActions.execute_script_float },
				{ mode = "n", key = "<C-f>", action = OpenActions.execute_script_float },
				{ mode = "i", key = "<C-v>", action = OpenActions.execute_script_vertical },
				{ mode = "n", key = "<C-v>", action = OpenActions.execute_script_vertical },
			},
		}

		require("project_cli_commands").setup(config)

		vim.api.nvim_set_keymap(
			"n",
			"<leader>pp",
			":Telescope project_cli_commands open<cr>",
			{ desc = "[P]roject CLI [C]ommands: Open", noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ph",
			":Telescope project_cli_commands running<cr>",
			{ desc = "[P]roject CLI Commands: Show [R]unning commands", noremap = true, silent = true }
		)

		vim.keymap.set("n", "<leader>pt", function()
			require("project_cli_commands").open({ default_text = "mvn:test" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: [T]est" })

		vim.keymap.set("n", "<leader>pc", function()
			require("project_cli_commands").open({ default_text = "mvn:compile" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: [C]ompile" })

		vim.keymap.set("n", "<leader>pg", function()
			require("project_cli_commands").open({ default_text = "mvn:package" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: Packa[G]e" })

		vim.keymap.set("n", "<leader>pi", function()
			require("project_cli_commands").open({ default_text = "mvn:install" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: [I]stall" })
		vim.keymap.set("n", "<leader>px", function()
			require("project_cli_commands").open({ default_text = "mvn:clean" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: Clean [X]" })

		vim.keymap.set("n", "<leader>pfc", function()
			require("project_cli_commands").open({ default_text = "mvn:spotless:check" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: [F]ormat [C]heck" })
		vim.keymap.set("n", "<leader>pfa", function()
			require("project_cli_commands").open({ default_text = "mvn:spotless:apply" })
			vim.defer_fn(function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", false)
			end, 100)
		end, { desc = "[P]roject: [F]ormat [A]pply" })
	end,
}
