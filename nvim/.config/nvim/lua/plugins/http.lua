return {
	"heilgar/nvim-http-client",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- "hrsh7th/nvim-cmp", -- Optional but recommended for enhanced autocompletion
		"nvim-telescope/telescope.nvim", -- Optional for better environment selection
	},
	event = "VeryLazy",
	ft = { "http", "rest" },
	config = function()
		require("http_client").setup({
			-- Default configuration (works out of the box)
			default_env_file = ".env.json",
			request_timeout = 30000,
			split_direction = "right",
			create_keybindings = true,

			-- Profiling (timing metrics for requests)
			profiling = {
				enabled = true,
				show_in_response = true,
				detailed_metrics = true,
			},

			-- Default keybindings (can be customized)
			keybindings = {
				select_env_file = "<leader>vf",
				set_env = "<leader>ve",
				run_request = "<leader>vr",
				stop_request = "<leader>vx",
				toggle_verbose = "<leader>vv",
				toggle_profiling = "<leader>vp",
				dry_run = "<leader>vd",
				copy_curl = "<leader>vc",
				save_response = "<leader>vs",
			},
		})

		-- Add keybinding descriptions
		local which_key = require("which-key")
		which_key.add({
			{ "<leader>v", group = "Run HTTP requests" },
			{
				"<leader>vf",
				desc = "HTTP Select environment [F]ile",
			},
			{
				"<leader>ve",
				desc = "HTTP Set [E]nvironment",
			},
			{
				"<leader>vr",
				desc = "HTTP [R]un request",
			},
			{ "<leader>vx", desc = "HTTP Stop request [X]" },
			{ "<leader>vv", desc = "HTTP Toggle [V]erbose" },
			{ "<leader>vp", desc = "HTTP Toggle [P]rofiling" },
			{
				"<leader>vd",
				desc = "HTTP [D]ry run",
			},
			{ "<leader>vc", desc = "HTTP Copy [C]url" },
			{ "<leader>vs", desc = "HTTP [S]ave response" },
		})
		-- Set up Telescope integration if available
		if pcall(require, "telescope") then
			require("telescope").load_extension("http_client")
		end
	end,
}
