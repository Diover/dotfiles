-- Directory of the current buffer: the listing directory when inside oil,
-- otherwise the directory holding the file. Falls back to nvim's cwd.
local function get_buffer_dir()
	if vim.bo.filetype == "oil" then
		local oil_dir = require("oil").get_current_dir()
		if oil_dir and oil_dir ~= "" then
			return (oil_dir:gsub("/+$", ""))
		end
	end
	local buf_dir = vim.fn.expand("%:p:h")
	if buf_dir == "" then
		return vim.fn.getcwd()
	end
	return buf_dir
end

-- Single terminal shared by <leader>tc and <leader>tt, created lazily on the
-- first press.
local cwd_term

local function toggle_term_in(dir)
	local Terminal = require("toggleterm.terminal").Terminal
	if not cwd_term then
		-- `dir` is only honoured while spawning, so the first press fixes the cwd
		cwd_term = Terminal:new({ dir = dir })
	else
		-- from now on cd the running shell instead of respawning
		cwd_term:change_dir(dir)
	end
	cwd_term:toggle()
end

return {
	{
		"akinsho/nvim-toggleterm.lua",
		keys = {
			{
				"<leader>tc",
				function()
					toggle_term_in(get_buffer_dir())
				end,
				desc = "[T]oggle terminal in the [c]urrent directory",
			},
			{
				"<leader>tt",
				function()
					toggle_term_in(vim.fn.getcwd())
				end,
				desc = "[T]oggle [T]erminal in nvim's working directory",
			},
		},
		config = function()
			require("toggleterm").setup({
				direction = "vertical",
				highlights = { FloatBorder = { link = "FloatBorder" } },
				open_mapping = [[<c-\>]],
				on_create = function(term)
					local opts = { buffer = term.bufnr }
					vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
				end,
				shading_factor = -20,
			})
		end,
	},
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		dependencies = {
			"akinsho/nvim-toggleterm.lua",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
		},
		config = true,
	},
}
