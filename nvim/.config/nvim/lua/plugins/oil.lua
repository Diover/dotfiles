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
		},
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				return name == "node_modules" or name == ".." or name == ".git"
			end,
		},
		skip_confirm_for_simple_edits = true,
		constrain_cursor = "editable",
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
					else
						require("oil").set_columns({ "icon" })
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
					local filename = vim.fn.expand("<cWORD>"):gsub("/+$", "")
					vim.fn.setreg("+", filename)
				end,
			},
			["<leader>cb"] = {
				desc = "[C]opy [B]ase name",
				callback = function()
					-- Copy the word under cursor, remove trailing "/", get the basename (remove extensions)
					local filename = vim.fn.expand("<cWORD>"):gsub("/+$", "")
					vim.fn.setreg("+", vim.fn.fnamemodify(filename, ":t:r"))
				end,
			},
			["<leader>cc"] = {
				desc = "[C]opy file path",
				callback = function()
					-- Get cwd and remove trailing "/"
					local current_dir = require("oil").get_current_dir()
					local filename = vim.fn.expand("<cWORD>"):gsub("/+$", "")
					vim.fn.setreg("+", current_dir .. filename)
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
		-- Set up oil
		require("oil").setup(opts)
	end,
}
