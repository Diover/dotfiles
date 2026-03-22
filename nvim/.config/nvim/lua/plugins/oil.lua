local detail = false
return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		win_options = {
			winbar = "%{v:lua.require('oil').get_current_dir()}",
			signcolumn = "yes:2",
		},
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				return name == "node_modules" or name == ".." or name == ".git"
			end,
		},
		skip_confirm_for_simple_edits = true,
		constrain_cursor = "name",
		watch_for_changes = true,
		lsp_file_methods = {
			-- Set to true to autosave buffers that are updated with LSP willRenameFiles
			-- Set to "unmodified" to only save unmodified buffers
			autosave_changes = true,
		},
		keymaps = {
			["q"] = { "actions.close", mode = "n" },
			["<C-r>"] = "actions.refresh",
			["<C-.>"] = { "actions.toggle_hidden", mode = "n" },
			["t."] = { "actions.toggle_hidden", mode = "n" },
			["td"] = {
				desc = "Toggle file detail view",
				callback = function()
					detail = not detail
					if detail then
						require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						require("oil.config").constrain_cursor = "editable"
					else
						require("oil").set_columns({ "icon" })
						require("oil.config").constrain_cursor = "name"
					end
				end,
			},
			["<leader>cd"] = {
				desc = "[C]opy current [D]irectory",
				callback = function()
					-- Get cwd and remove trailing "/"
					local current_dir = require("oil").get_current_dir():gsub("/+$", "")
					vim.fn.setreg("+", current_dir)
				end,
			},
			["<leader>cf"] = {
				desc = "[C]opy [F]ilename",
				callback = function()
					vim.fn.setreg("+", require("oil").get_cursor_entry().name)
				end,
			},
			["<leader>cb"] = {
				desc = "[C]opy [B]ase name",
				callback = function()
					-- Copy the word under cursor, get the basename (remove extensions)
					vim.fn.setreg("+", vim.fn.fnamemodify(require("oil").get_cursor_entry().name, ":t:r"))
				end,
			},
			["<leader>cc"] = {
				desc = "[C]opy file path",
				callback = function()
					local oil = require("oil")
					vim.fn.setreg("+", oil.get_current_dir() .. oil.get_cursor_entry().name)
				end,
			},
		},
		git = {
			-- Return true to automatically git add/mv/rm files
			add = function(path)
				return true
			end,
			mv = function(src_path, dest_path)
				return true
			end,
			rm = function(path)
				return true
			end,
		},
	},
	-- Optional dependencies
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} },
	},
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function(_, opts)
		require("oil").setup(opts)

		-- After oil renders, snap cursor to the file name column
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilEnter",
			callback = function(args)
				vim.schedule(function()
					local bufnr = args.data and args.data.buf or vim.api.nvim_get_current_buf()
					if not vim.api.nvim_buf_is_valid(bufnr) or bufnr ~= vim.api.nvim_get_current_buf() then
						return
					end
					local cur = vim.api.nvim_win_get_cursor(0)
					local line = vim.api.nvim_buf_get_lines(bufnr, cur[1] - 1, cur[1], true)[1]
					if not line then
						return
					end
					local adapter = require("oil.util").get_adapter(bufnr, true)
					if not adapter then
						return
					end
					local column_defs = require("oil.columns").get_supported_columns(adapter)
					local result = require("oil.mutator.parser").parse_line(adapter, line, column_defs)
					if result and result.ranges and result.ranges.name then
						local name_col = result.ranges.name[1]
						if cur[2] < name_col then
							vim.api.nvim_win_set_cursor(0, { cur[1], name_col })
						end
					end
				end)
			end,
		})
	end,
}
