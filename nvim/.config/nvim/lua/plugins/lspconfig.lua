return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{
			"mason-org/mason.nvim",
			opts = {
				PATH = "append",
			},
		},
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"nvim-telescope/telescope.nvim",
		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by blink.cmp
		"saghen/blink.cmp",
		{
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local function smart_path_display(_, path)
			local sep = "/"
			local parts = vim.split(path, sep, { plain = true })
			if parts[1] == "" then
				table.remove(parts, 1)
			end
			if #parts <= 3 then
				return path
			end
			local filename = parts[#parts]
			local dirs = { unpack(parts, 1, #parts - 1) }
			local max_w = 20

			-- first/…/second-to-last/last/filename
			local d = dirs[1] .. "/…/" .. dirs[#dirs - 1] .. "/" .. dirs[#dirs] .. "/" .. filename
			if #d <= max_w then
				return d
			end
			-- shorten first dir to 2 chars
			d = dirs[1]:sub(1, 2) .. "/…/" .. dirs[#dirs - 1] .. "/" .. dirs[#dirs] .. "/" .. filename
			if #d <= max_w then
				return d
			end
			-- also shorten second-to-last dir
			d = dirs[1]:sub(1, 2) .. "/…/" .. dirs[#dirs - 1]:sub(1, 2) .. "/" .. dirs[#dirs] .. "/" .. filename
			if #d <= max_w then
				return d
			end
			-- parent/filename only
			d = dirs[#dirs] .. "/" .. filename
			if #d <= max_w then
				return d
			end
			-- filename only
			return filename
		end

		local symbol_picker_opts = {
			path_display = smart_path_display,
			fname_width = 30,
			symbol_width = 30,
		}

		--  This function gets run when an LSP attaches to a particular buffer.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("grr", function()
					require("telescope.builtin").lsp_references(symbol_picker_opts)
				end, "[G]oto [R]eferences")
				map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				--  Jump to the definition of the word's under the cursor *type*, not where it was *defined*.
				map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
				--  In C this would take you to the header.
				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				map("gd", function()
					require("telescope.builtin").lsp_document_symbols(symbol_picker_opts)
				end, "Open Document Symbols")
				map("gs", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols(symbol_picker_opts)
				end, "Open Workspace Symbols")

				map("gco", require("telescope.builtin").lsp_outgoing_calls, "[G]oto [C]alls [O]utgoing")
				map("gci", require("telescope.builtin").lsp_incoming_calls, "[G]oto [C]alls [I]utgoing ")

				-- Turn off the LSP diagnostic messages if it becomes too noisy
				map("<leader>th", function()
					vim.diagnostic.enable(not vim.diagnostic.is_enabled())
				end, "[T]oggle Diagnostic [H]ints")
			end,
		})

		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = false,
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = true,
			virtual_lines = true,
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Enable the following language servers
		local servers = {
			pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = {
					{
						".conda",
						".venv",
					},
					{
						"pyproject.toml",
						"setup.py",
						"setup.cfg",
						"requirements.txt",
						"Pipfile",
						"pyrightconfig.json",
					},
					".git",
				},
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			},
			rust_analyzer = {},
			lua_ls = {
				-- cmd = { ... },
				-- filetypes = { ... },
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}

		-- Override terraform-ls filetypes to suppress unknown filetype warning
		vim.lsp.config("terraformls", {
			filetypes = { "terraform" },
		})

		-- Configure jdtls via vim.lsp.config (required for automatic_enable)
		local jdk21 = vim.fn.system("/usr/libexec/java_home -v 21 2>/dev/null"):gsub("%s+$", "")
		if jdk21 ~= "" then
			local runtimes = {}
			local jdk_specs = {
				{ version = "1.8", name = "JavaSE-1.8" },
				{ version = "11", name = "JavaSE-11" },
				{ version = "21", name = "JavaSE-21", default = true },
			}
			for _, spec in ipairs(jdk_specs) do
				local path =
					vim.fn.system("/usr/libexec/java_home -v " .. spec.version .. " 2>/dev/null"):gsub("%s+$", "")
				if path ~= "" and vim.fn.isdirectory(path) == 1 then
					table.insert(runtimes, {
						name = spec.name,
						path = path,
						default = spec.default or false,
					})
				end
			end
			local lombok_jar = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
			vim.lsp.config("jdtls", {
				cmd = {
					"jdtls",
					"--java-executable",
					jdk21 .. "/bin/java",
					"--jvm-arg=-javaagent:" .. lombok_jar,
				},
				settings = {
					java = {
						configuration = {
							runtimes = runtimes,
						},
					},
				},
			})
		end

		-- Ensure the servers and tools above are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Set up servers via vim.lsp.config (nvim 0.11+)
		for server_name, server in pairs(servers) do
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			vim.lsp.config(server_name, server)
		end
		vim.lsp.enable(vim.tbl_keys(servers))

		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_enable = true,
			automatic_installation = false,
		})
	end,
}
