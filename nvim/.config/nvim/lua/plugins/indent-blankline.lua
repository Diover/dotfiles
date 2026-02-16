-- Uncomment after (this)[https://github.com/lukas-reineke/indent-blankline.nvim/issues/649] is implemented
-- return {
-- 	"lukas-reineke/indent-blankline.nvim",
-- 	main = "ibl",
-- 	---@module "ibl"
-- 	---@type ibl.config
-- 	opts = {
-- 		indent = {
-- 			char = "▏",
-- 		},
-- 	},
-- }
return {
	"kiyoon/indent-blankline-v2.nvim",
	event = "BufReadPost",
	config = function()
		vim.opt.list = true
		require("indent_blankline").setup({
			space_char_blankline = " ",
			show_current_context = true,
			show_current_context_start = true,
		})
	end,
}
