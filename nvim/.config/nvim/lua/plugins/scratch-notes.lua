return {
	"leobeosab/brr.nvim",
	opts = {},
	keys = {
		{ "<leader>..", "<cmd>Scratch global-scratch-note.md<cr>", desc = "Open persistent scratch note" },
		{ "<leader>.d", "<cmd>Scratch<cr>", desc = "Open daily scratch note" },
		{ "<leader>ss", "<cmd>ScratchList<cr>", desc = "Find scratch note file" },
	},
	config = function()
		local vaults_config_path = vim.fn.expand("$HOME/.vaults")
		local workspaces = {}

		if vim.fn.filereadable(vaults_config_path) == 1 then
			for line in io.lines(vaults_config_path) do
				local splits = vim.split(line, ":")
				table.insert(workspaces, {
					name = splits[1],
					path = vim.fn.expand(splits[2]),
				})
			end
		else
			workspaces = {
				{
					name = "personal",
					path = vim.env.HOME .. "/vaults/personal",
				},
			}
		end
		local first_found_vault = workspaces[1].path

		require("brr").setup({
			root = first_found_vault .. "/scratch/", -- Root where all scratch files are stored
			style = {
				width = 1, -- 0-1, 1 being full width
				height = 1, -- 0-1
				title_padding = 2, -- number of spaces as padding in the top border title
			},
		})
	end,
}
