-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange" })

				-- Actions
				-- visual mode
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [s]tage hunk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [r]eset hunk" })
				-- normal mode
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [H]unk [S]tage" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [H]unk [R]eset" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git [S]tage buffer" })
				map("n", "<leader>hu", gitsigns.stage_hunk, { desc = "Git [H]unk [U]ndo stage" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [R]eset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk_inline, { desc = "Git [H]unk [P]review" })
				map("n", "<leader>hb", gitsigns.blame, { desc = "Git [H]unk [B]lame " })
				map("n", "<leader>hB", gitsigns.blame_line, { desc = "Git [H]unk [B]lame line" })
				-- Not sure how useful are these ones:
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [H]unk open [D]iff against index" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })
			end,
		},
	},
}
