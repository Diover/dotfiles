return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local lualine = require("lualine")

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				globalstatus = true,
				always_divide_middle = true,
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				-- Full path
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					function()
						local encoding = vim.o.fileencoding
						if encoding == "" then
							return vim.bo.fileformat .. " :: " .. vim.bo.filetype
						else
							return encoding .. " :: " .. vim.bo.fileformat .. " :: " .. vim.bo.filetype
						end
					end,
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
