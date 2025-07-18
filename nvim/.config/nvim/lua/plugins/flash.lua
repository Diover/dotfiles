return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			-- options used when flash is activated through
			-- a regular search with `/` or `?`
			search = {
				-- when `true`, flash will be activated during regular search by default.
				-- You can always toggle when searching with `require("flash").toggle()`
				enabled = true,
			},
		},
		search = {
			-- search/jump in all windows
			multi_window = false,
		},
	},
	keys = {
		{
			"sx",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash: [S]earch and jump to [x] target",
		},
		{
			"sX",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash: Treesitter [S]earch and jump to [X] target",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Flash: [R]emote (operator mode)",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Flash: [R]emote Treesitter search around target",
		},
	},
}
