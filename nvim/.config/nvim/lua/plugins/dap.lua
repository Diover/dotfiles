local function set_up_breakpoint_colors()
	-- Set up colors for the breakpoints
	-- augroup to be able to trigger the autocommand explicitly for the first time
	vim.api.nvim_create_augroup("dap_colors", {})

	-- autocmd to enforce colors settings on any color scheme change
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "dap_colors",
		pattern = "*",
		desc = "Set DAP marker colors and prevent color theme from resetting them",
		callback = function()
			-- Reuse current SignColumn background (except for DapStoppedLine)
			local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })
			-- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
			-- convert to 6 digit hex value starting with #
			local sign_column_bg = (sign_column_hl.bg ~= nil) and ("#%06x"):format(sign_column_hl.bg) or "bg"
			local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or "Black"

			vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00ff00", bg = sign_column_bg, ctermbg = sign_column_ctermbg })
			vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d", ctermbg = "Green" })
			vim.api.nvim_set_hl(
				0,
				"DapBreakpoint",
				{ fg = "#c23127", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
			)
			vim.api.nvim_set_hl(
				0,
				"DapBreakpointRejected",
				{ fg = "#888ca6", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
			)
			vim.api.nvim_set_hl(
				0,
				"DapLogPoint",
				{ fg = "#61afef", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
			)
		end,
	})

	-- executing the settings explicitly for the first time
	vim.api.nvim_exec_autocmds("ColorScheme", { group = "dap_colors" })
	vim.fn.sign_define("DapBreakpoint", { text = " B", texthl = "DapBreakpoint" })
	vim.fn.sign_define("DapBreakpointCondition", { text = " C", texthl = "DapBreakpoint" })
	vim.fn.sign_define("DapBreakpointRejected", { text = " R", texthl = "DapBreakpoint" })
	vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint" })
	vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped" })
end

local function get_default_python_executable()
	local python_executable = os.getenv("HOME") .. "/miniconda3/envs/debugpy/bin/python"
	assert(
		vim.fn.executable(python_executable) == 1,
		'Please create "debugpy" environment in miniconda3 to use python with dap'
	)
	return python_executable
end

local function get_workspace_python_executable()
	local lsp_root = vim.lsp.buf.list_workspace_folders()[1]
	print("LSP root: " .. lsp_root)
	local workspace_root = lsp_root or vim.fn.cwd()
	if vim.fn.executable(workspace_root .. "/.conda/bin/python") == 1 then
		return workspace_root .. "/.conda/bin/python"
	elseif vim.fn.executable(workspace_root .. "/.venv/bin/python") == 1 then
		return workspace_root .. "/.venv/bin/python"
	else
		return get_default_python_executable()
	end
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				opts = {
					windows = {
						terminal = {
							-- Use the actual names for the adapters you want to hide the terminal window for
							hide = { "python" },
						},
					},
				},
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

					vim.keymap.set(
						"n",
						"<leader>db",
						":PBToggleBreakpoint<CR>",
						{ desc = "[D]ebug toggle [B]reakpoint" }
					)
				end,
			},
			{
				"nvim-neotest/neotest",
				dependencies = {
					"mfussenegger/nvim-dap",
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
								python = function()
									-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
									local workspace_python_executable = get_workspace_python_executable()
									print(
										"Using the following python path for this workspace: "
											.. workspace_python_executable
									)
									return workspace_python_executable
								end,

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

					vim.keymap.set(
						"n",
						"<leader>tR",
						require("neotest").run.run,
						{ desc = "[T]est [R]un all in the current file" }
					)

					vim.keymap.set("n", "<leader>tr", function()
						require("neotest").run.run(vim.fn.expand("%"))
					end, { desc = "[T]est [R]un nearest test" })

					vim.keymap.set("n", "<leader>td", function()
						require("neotest").run.run({ strategy = "dap" })
					end, { desc = "[T]est [D]ebug nearest test" })

					vim.keymap.set("n", "<leader>tq", function()
						require("neotest").run.stop()
					end, { desc = "[T]est Stop running tests" })
				end,
			},
		},
		config = function()
			--Set up configurations
			local dap, dv = require("dap"), require("dap-view")

			-- AUtomatic toggle for the nvim-dap-view at the start/end of the debug session
			dap.listeners.before.attach["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.launch["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.event_terminated["dap-view-config"] = function()
				dv.close()
			end
			dap.listeners.before.event_exited["dap-view-config"] = function()
				dv.close()
			end
			-- Don't change focus if the window is visible, otherwise jump to the first window (from any tab) containing the buffer
			-- If no window contains the buffer, create a new tab
			dap.defaults.fallback.switchbuf = "useopen,usevisible,usetab,newtab"

			dap.adapters.python = function(cb, config)
				if config.request == "attach" then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or "127.0.0.1"
					cb({
						type = "server",
						port = assert(port, "`connect.port` is required for a python `attach` configuration"),
						host = host,
						options = {
							source_filetype = "python",
						},
					})
				else
					cb({
						type = "executable",
						command = get_default_python_executable(),
						args = { "-m", "debugpy.adapter" },
						options = {
							source_filetype = "python",
						},
					})
				end
			end

			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here establishes the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch current file",

					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						local workspace_python_executable = get_workspace_python_executable()
						print("Using the following python path for this workspace: " .. workspace_python_executable)
						return workspace_python_executable
					end,
				},
			}

			vim.keymap.set("n", "<leader>dR", "<cmd>lua require'dap'.run_last()<cr>", { desc = "[D]ebug [R]un last" })
			vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<cr>", { desc = "[D]ebug [C]ontinue or Run" })
			vim.keymap.set(
				"n",
				"<leader>dd",
				"<cmd>Telescope dap configurations<cr>",
				{ desc = "[D]ebug show [D]ebug configurations via Telescope" }
			)
			vim.keymap.set("n", "<leader>dq", "<cmd>DapTerminate<cr>", { desc = "[D]ebug Terminate" })
			-- vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>",  {desc = "Toggle breakpoint" })
			vim.keymap.set(
				"n",
				"<leader>dB",
				"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
				{ desc = "[D]ebug set conditional [B]reakpoint" }
			)
			vim.keymap.set(
				"n",
				"<leader>dp",
				"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
				{ desc = "[D]ebug set log point breakpoint ([P]rint statement)" }
			)
			vim.keymap.set("n", "<leader>dj", "<cmd>DapStepOver<cr>", { desc = "[D]ebug step over (Down)" })
			vim.keymap.set("n", "<leader>dl", "<cmd>DapStepInto<cr>", { desc = "[D]ebug step into (Right)" })
			vim.keymap.set("n", "<leader>dk", "<cmd>DapStepOut<cr>", { desc = "[D]ebug step out (Up)" })
			vim.keymap.set("n", "<leader>dO", "<cmd>DapToggleRepl<cr>", { desc = "[D]ebug [O]pen repl" })
			vim.keymap.set("n", "<leader>do", "<cmd>:DapViewJump repl<cr>", { desc = "[D]ebug [O]pen repl" })
			vim.keymap.set(
				"n",
				"<leader>du",
				"<cmd>lua require'dap-view'.toggle()<cr>",
				{ desc = "[D]ebug toggle debugging [U]I" }
			)
			vim.keymap.set(
				"n",
				"<leader>ds",
				"<cmd>Telescope dap list_breakpoints<cr>",
				{ desc = "[D]ebug [s]how all breakpoints via Telescope" }
			)
			vim.keymap.set(
				"n",
				"<leader>dv",
				"<cmd>Telescope dap variables<cr>",
				{ desc = "[D]ebug show all [V]ariables via Telescope" }
			)

			set_up_breakpoint_colors()
		end,
	},
}
