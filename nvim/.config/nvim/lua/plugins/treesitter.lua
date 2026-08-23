local languages = {
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"html",
	"diff",
	"vim",
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
	"json",
	"xml",
	"regex",
	"hcl",
	"terraform",
}
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		-- Work only within the context of a buffer
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- replicate `ensure_installed`, runs asynchronously, skips existing languages
			require("nvim-treesitter").install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter.setup", {}),
				callback = function(args)
					local buf = args.buf
					local filetype = args.match

					-- kulala.nvim manages its own treesitter lifecycle for http/rest
					if filetype == "http" or filetype == "rest" then
						return
					end

					-- you need some mechanism to avoid running on buffers that do not
					-- correspond to a language (like oil.nvim buffers), this implementation
					-- checks if a parser exists for the current language
					local language = vim.treesitter.language.get_lang(filetype) or filetype
					if not vim.treesitter.language.add(language) then
						return
					end

					-- replicate `fold = { enable = true }`
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

					-- replicate `highlight = { enable = true }`
					vim.treesitter.start(buf, language)

					-- replicate `indent = { enable = true }`
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			highlight = {
				enable = false,
			},
			incremental_selection = {
				enable = true,
				-- set value to `false` to disable individual mapping
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "v",
					scope_incremental = false,
					node_decremental = "V",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter" },
		branch = "main",
		config = function()
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")
			local repeatable_move = require("nvim-treesitter-textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			vim.keymap.set({ "n", "x", "o" }, ";", repeatable_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", repeatable_move.repeat_last_move_opposite)

			-- Make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", repeatable_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", repeatable_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", repeatable_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", repeatable_move.builtin_T_expr, { expr = true })

			require("nvim-treesitter-textobjects").setup({
				move = {
					set_jumps = true,
				},
			})

			-- Move: jump between code structures
			local move_maps = {
				{ "]f", move.goto_next_start, "@function.outer", "Next function start" },
				{ "[f", move.goto_previous_start, "@function.outer", "Prev function start" },
				{ "]F", move.goto_next_end, "@function.outer", "Next function end" },
				{ "[F", move.goto_previous_end, "@function.outer", "Prev function end" },
				{ "]c", move.goto_next_start, "@class.outer", "Next class start" },
				{ "[c", move.goto_previous_start, "@class.outer", "Prev class start" },
				{ "]C", move.goto_next_end, "@class.outer", "Next class end" },
				{ "[C", move.goto_previous_end, "@class.outer", "Prev class end" },
				{ "]r", move.goto_next_start, "@return.outer", "Next return statement" },
				{ "[r", move.goto_previous_start, "@return.outer", "Prev return statement" },
				{ "]l", move.goto_next_start, "@loop.outer", "Next loop" },
				{ "[l", move.goto_previous_start, "@loop.outer", "Prev loop" },
				{ "]i", move.goto_next_start, "@conditional.outer", "Next conditional" },
				{ "[i", move.goto_previous_start, "@conditional.outer", "Prev conditional" },
				{ "]x", move.goto_next_start, "@call.outer", "Next call" },
				{ "[x", move.goto_previous_start, "@call.outer", "Prev call" },
			}
			for _, m in ipairs(move_maps) do
				vim.keymap.set({ "n", "x", "o" }, m[1], function()
					m[2](m[3])
				end, { desc = m[4] })
			end

			-- Swap: parameters
			vim.keymap.set("n", "<leader>a", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap parameter with next" })
			vim.keymap.set("n", "<leader>A", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap parameter with previous" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter" },
		opts = {},
	},
	{
		"kiyoon/treesitter-indent-object.nvim",
		dependencies = { "nvim-treesitter" },
		keys = {
			{
				"ai",
				function()
					require("treesitter_indent_object.textobj").select_indent_outer()
				end,
				mode = { "x", "o" },
				desc = "Select context-aware indent (outer)",
			},
			{
				"aI",
				function()
					require("treesitter_indent_object.textobj").select_indent_outer(true, "V")
					require("treesitter_indent_object.refiner").include_surrounding_empty_lines()
				end,
				mode = { "x", "o" },
				desc = "Select context-aware indent (outer, line-wise)",
			},
			{
				"ii",
				function()
					require("treesitter_indent_object.textobj").select_indent_inner()
				end,
				mode = { "x", "o" },
				desc = "Select context-aware indent (inner, partial range)",
			},
			{
				"iI",
				function()
					require("treesitter_indent_object.textobj").select_indent_inner(true, "V")
				end,
				mode = { "x", "o" },
				desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
			},
		},
	},
	{
		"andymass/vim-matchup",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			treesitter = {
				stopline = 1000,
			},
		},
	},
}
