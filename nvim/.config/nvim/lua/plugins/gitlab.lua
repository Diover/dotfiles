return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim",
		"nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
	},
	build = function()
		require("gitlab.server").build(true)
	end, -- Builds the Go binary
	config = function()
		local gitlab_auth_token = "unknown_token"
		local gitlab_url = "unknown_url"
		local gitlab_config_path = vim.fn.expand("$HOME/.gitlab.nvim")

		if vim.fn.filereadable(gitlab_config_path) == 1 then
			for line in io.lines(gitlab_config_path) do
				local splits = vim.split(line, "=")
				if splits[1] == "auth_token" then
					gitlab_auth_token = splits[2]
				end
				if splits[1] == "gitlab_url" then
					gitlab_url = splits[2]
				end
			end
		end
		require("gitlab").setup({
			auth_provider = function()
				return gitlab_auth_token, gitlab_url, nil
			end,
		})
	end,
}
