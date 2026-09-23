return {
	"s0cks/taskfile.nvim",
	opts = {},
	config = function(_, opts)
		require("taskfile").setup(opts)
	end,
}
