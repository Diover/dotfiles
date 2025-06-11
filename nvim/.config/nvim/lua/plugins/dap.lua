return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				opts = {},
				config = function(_, opts)
					vim.api.nvim_create_autocmd({ "FileType" }, {
						pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
						callback = function(evt)
							vim.keymap.set("n", "q", "<C-w>q", { buffer = evt.buf })
						end,
					})

					require("dap-view").setup(opts)
				end,
			},
			{
				"Weissle/persistent-breakpoints.nvim",
				config = function()
					require("persistent-breakpoints").setup({
						load_breakpoints_event = { "BufReadPost" },
					})

					vim.keymap.set("n", "<leader>db", ":PBToggleBreakpoint<CR>", { desc = "[DAP] Toggle breakpoint" })
				end,
			},
			{
				"nvim-neotest/neotest",
				dependencies = {
					"nvim-neotest/nvim-nio",
					"nvim-neotest/neotest-python",
					"nvim-lua/plenary.nvim",
					"antoinemadec/FixCursorHold.nvim",
					"nvim-treesitter/nvim-treesitter",
				},
				config = function()
					require("neotest").setup({
						adapters = {
							require("neotest-python")({
								-- Extra arguments for nvim-dap configuration
								-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
								dap = { justMyCode = false },
								-- Command line arguments for runner
								-- Can also be a function to return dynamic values
								args = { "--log-level", "DEBUG" },
								-- Runner to use. Will use pytest if available by default.
								-- Can be a function to return dynamic value.
								runner = "pytest",
								-- Custom python path for the runner.
								-- Can be a string or a list of strings.
								-- Can also be a function to return dynamic value.
								-- If not provided, the path will be inferred by checking for
								-- virtual envs in the local directory and for Pipenev/Poetry configs
								-- python = ".venv/bin/python",

								-- Returns if a given file path is a test file.
								-- NB: This function is called a lot so don't perform any heavy tasks within it.
								-- is_test_file = function(file_path)
								-- end,

								-- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
								-- instances for files containing a parametrize mark (default: false)
								pytest_discover_instances = true,
							}),
						},
					})
				end,
			},
		},
		config = function()
			vim.keymap.set("n", "<leader>dR", "<cmd>lua require'dap'.run()<cr>", { desc = "[DAP] Run" })
			vim.keymap.set("n", "<leader>de", "<cmd>lua require'dap'.run_last()<cr>", { desc = "[DAP] Debug last" })
			vim.keymap.set(
				"n",
				"<leader>dE",
				"<cmd>Telescope dap configurations<cr>",
				{ desc = "[DAP] Show debug configurations" }
			)
			vim.keymap.set("n", "<leader>dk", "<cmd>DapTerminate<cr>", { desc = "[DAP] Terminate" })
			-- vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>",  {desc = "[DAP] Toggle breakpoint" })
			vim.keymap.set(
				"n",
				"<leader>dB",
				"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
				{ desc = "[DAP] Set conditional breakpoint" }
			)
			vim.keymap.set(
				"n",
				"<leader>dl",
				"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
				{ desc = "[DAP] Set log point breakpoint" }
			)
			vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "[DAP] Continue" })
			vim.keymap.set("n", "<leader>dv", "<cmd>DapStepOver<cr>", { desc = "[DAP] Step oVer" })
			vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "[DAP] Step Into" })
			vim.keymap.set("n", "<leader>do", "<cmd>DapStepOut<cr>", { desc = "[DAP] Step Out" })
			vim.keymap.set("n", "<leader>dp", "<cmd>DapToggleRepl<cr>", { desc = "[DAP] Repl open" })
			vim.keymap.set(
				"n",
				"<leader>du",
				"<cmd>lua require'dap-view'.toggle()<cr>",
				{ desc = "[DAPUI] Toggle debugging UI" }
			)
			vim.keymap.set(
				"n",
				"<leader>ds",
				"<cmd>Telescope dap list_breakpoints<cr>",
				{ desc = "[TELESCOPE DAP] Show all breakpoints" }
			)
			vim.keymap.set(
				"n",
				"<leader>dw",
				"<cmd>Telescope dap variables<cr>",
				{ desc = "[TELESCOPE DAP] Variables" }
			)
		end,
		-- lazy = true,
	},
}
