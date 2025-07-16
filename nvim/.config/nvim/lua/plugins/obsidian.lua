return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/personal",
			},
			{
				name = "work",
				path = "~/vaults/work",
			},
		},
		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
			name = "telescope.nvim",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support all mappings.
			note_mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- Add tag(s) to current note.
				tag_note = "<C-x>",
				-- Insert a tag at the current location.
				insert_tag = "<C-l>",
			},
		},
		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "daily",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily-notes" },
		},
		-- Optional, customize how note IDs are generated given an optional title.
		---@param title string|?
		---@return string
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
		attachments = {
			-- The default folder to place images in via `:ObsidianPasteImg`.
			-- If this is a relative path it will be interpreted as relative to the vault root.
			-- You can always override this per image by passing a full path to the command instead of just a filename.
			img_folder = "assets/imgs", -- This is the default
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>n."] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<leader>n,"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		completion = {
			-- Enables completion using nvim_cmp
			nvim_cmp = false,
			-- Enables completion using blink.cmp
			blink = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
			-- Set to false to disable new note creation in the picker
			create_new = true,
		},
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ "open", url }) -- Mac OS
		end,

		ui = {
			enable = false,
			checkboxes = {
				["x"] = { char = "󰱒", hl_group = "ObsidianDone" },
			},
		},
	},
	config = function(_, opts)
		require("obsidian").setup(opts)
		-- vim.keymap.set({ "n" }, "<leader>nn", function()
		-- 	local input = vim.fn.input({ prompt = "New Note Title" })
		-- 	vim.cmd("Obsidian new '" .. input .. "'")
		-- end, { noremap = true, silent = true })
		vim.keymap.set({ "n", "v" }, "<leader>nn", "<cmd>Obsidian new<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n", "v" }, "<leader>no", "<cmd>Obsidian open<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>nq", "<cmd>Obsidian quick_switch<cr>", { noremap = true, silent = true })

		vim.keymap.set({ "n" }, "<leader>nb", "<cmd>Obsidian backlinks<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n", "v" }, "<leader>nt", "<cmd>Obsidian tags<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>ns", "<cmd>Obsidian search<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>sn", "<cmd>Obsidian search<cr>", { noremap = true, silent = true })

		vim.keymap.set({ "n" }, "<leader>nw", "<cmd>Obsidian workspace<cr>", { noremap = true, silent = true })

		-- Link manipulation
		vim.keymap.set({ "n", "v" }, "<leader>nle", "<cmd>Obsidian extract_note<cr>", {
			noremap = true,
			silent = true,
			desc = "[E]xtract the visually selected text into a new note and link to it",
		})
		vim.keymap.set(
			{ "n" },
			"<leader>nls",
			"<cmd>Obsidian links<cr>",
			{ noremap = true, silent = true, desc = "Collect all links within the current buffer into a picker window" }
		)
		vim.keymap.set({ "n", "v" }, "<leader>nln", "<cmd>Obsidian link_new<cr>", {
			noremap = true,
			silent = true,
			desc = "to create a new note and link it to an inline visual selection of text",
		})
		vim.keymap.set({ "n", "v" }, "<leader>nll", "<cmd>Obsidian link<cr>", {
			noremap = true,
			silent = true,
			desc = "to link an inline visual selection of text to a note",
		})

		-- Dailies
		vim.keymap.set({ "n" }, "<leader>nd", "<cmd>Obsidian today<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>nD", "<cmd>Obsidian dailies<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>ny", "<cmd>Obsidian yesterday<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>nY", "<cmd>Obsidian tomorrow<cr>", { noremap = true, silent = true })

		vim.keymap.set({ "n" }, "<leader>ni", "<cmd>Obsidian paste_img<cr>", { noremap = true, silent = true })
		vim.keymap.set({ "n" }, "<leader>nc", "<cmd>Obsidian toc<cr>", { noremap = true, silent = true })
	end,
}
