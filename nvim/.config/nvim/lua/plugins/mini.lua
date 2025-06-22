return {
	{
		"echasnovski/mini.ai",
		version = "*",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			local ai = require("mini.ai")
			ai.setup({
				custom_textobjects = {
					a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
					c = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
					s = { -- Single words in different cases (camelCase, snake_case, etc.)
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[^%s%p][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
							"%f[^%s%p][%a%d]+%f[^%a%d]",
							"^[%a%d]+%f[^%a%d]",
						},
						"^().*()$",
					},
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					g = function() -- whole file
						local from = { line = 1, col = 1 }
						local to = {
							line = vim.fn.line("$"),
							col = math.max(vim.fn.getline("$"):len(), 1),
						}
						return { from = from, to = to }
					end,
				},
				mappings = {
					around = "a",
					inside = "i",

					around_next = "an",
					inside_next = "in",
					around_last = "ap",
					inside_last = "ip",

					goto_left = "g[",
					goto_right = "g]",
				},
				n_lines = 500,
			})
		end,
	},
	{
		"echasnovski/mini.cursorword",
		version = "*",
		config = function()
			require("mini.cursorword").setup({ delay = 100 })
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup({
				-- In which modes mappings from this `config` should be created
				modes = { insert = true, command = false, terminal = false },
				-- Global mappings. Each right hand side should be a pair information, a
				-- table with at least these fields (see more in |MiniPairs.map|):
				-- - <action> - one of 'open', 'close', 'closeopen'.
				-- - <pair> - two character string for pair to be used.
				-- By default pair is not inserted after `\`, quotes are not recognized by
				-- `<CR>`, `'` does not insert pair after a letter.
				-- Only parts of tables can be tweaked (others will use these defaults).
				mappings = {
					["["] = {
						action = "open",
						pair = "[]",
						neigh_pattern = ".[%s%z%)}%]]",
						register = { cr = false },
						-- foo|bar -> press "[" -> foo[bar
						-- foobar| -> press "[" -> foobar[]
						-- |foobar -> press "[" -> [foobar
						-- | foobar -> press "[" -> [] foobar
						-- foobar | -> press "[" -> foobar []
						-- {|} -> press "[" -> {[]}
						-- (|) -> press "[" -> ([])
						-- [|] -> press "[" -> [[]]
					},
					["{"] = {
						action = "open",
						pair = "{}",
						-- neigh_pattern = ".[%s%z%)}]",
						neigh_pattern = ".[%s%z%)}%]]",
						register = { cr = false },
						-- foo|bar -> press "{" -> foo{bar
						-- foobar| -> press "{" -> foobar{}
						-- |foobar -> press "{" -> {foobar
						-- | foobar -> press "{" -> {} foobar
						-- foobar | -> press "{" -> foobar {}
						-- (|) -> press "{" -> ({})
						-- {|} -> press "{" -> {{}}
					},
					["("] = {
						action = "open",
						pair = "()",
						-- neigh_pattern = ".[%s%z]",
						neigh_pattern = ".[%s%z%)]",
						register = { cr = false },
						-- foo|bar -> press "(" -> foo(bar
						-- foobar| -> press "(" -> foobar()
						-- |foobar -> press "(" -> (foobar
						-- | foobar -> press "(" -> () foobar
						-- foobar | -> press "(" -> foobar ()
					},
					[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
					["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
					["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
					-- Single quote: Prevent pairing if either side is a letter
					['"'] = {
						action = "closeopen",
						pair = '""',
						neigh_pattern = "[^%w\\][^%w]",
						register = { cr = false },
					},
					-- Single quote: Prevent pairing if either side is a letter
					["'"] = {
						action = "closeopen",
						pair = "''",
						neigh_pattern = "[^%w\\][^%w]",
						register = { cr = false },
					},
					-- Backtick: Prevent pairing if either side is a letter
					["`"] = {
						action = "closeopen",
						pair = "``",
						neigh_pattern = "[^%w\\][^%w]",
						register = { cr = false },
					},
				},
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup({
				-- Add custom surroundings to be used on top of builtin ones. For more
				-- information with examples, see `:h MiniSurround.config`.
				custom_surroundings = nil,

				-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
				highlight_duration = 1000,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					find = "sf", -- Find surrounding (to the right)
					find_left = "sF", -- Find surrounding (to the left)
					highlight = "sh", -- Highlight surrounding
					replace = "sr", -- Replace surrounding
					update_n_lines = "sn", -- Update `n_lines`
				},

				-- Number of lines within which surrounding is searched
				n_lines = 500,

				-- How to search for surrounding (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
				search_method = "cover_or_next",
			})
		end,
	},
}
