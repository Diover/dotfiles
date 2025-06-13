return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- Work only within the context of a buffer
		event = { "BufReadPre", "BufNewFile" },
		main = "nvim-treesitter.configs", -- Sets main module to use for opts

		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			-- A list of parser names, or "all"
			ensure_installed = {
				"lua",
				"markdown",
				"luadoc",
				"html",
				"diff",
				"vim",
				"markdown_inline",
				"query",
				"vimdoc",
				"javascript",
				"typescript",
				"c",
				"cpp",
				"rust",
				"lua",
				"bash",
				"python",
				"java",
				"yaml",
			},

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
			auto_install = true,

			indent = {
				enable = true,
				disable = { "ruby" },
			},

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = { "markdown", "ruby" },
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = "v",
					node_decremental = "V",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter" },
		config = function() end,
		opts = {
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["[f"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["]f"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						-- You can optionally set descriptions to the mappings (used in the desc parameter of
						-- nvim_buf_set_keymap) which plugins like which-key display
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
						["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
						-- You can also use captures from other query groups like `locals.scm`
						["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
					},
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true or false
					include_surrounding_whitespace = true,
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter" },
		opts = {},
	},
}
