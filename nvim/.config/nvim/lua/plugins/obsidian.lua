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
		legacy_commands = false,
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
			-- like '20250718-202345-my-new-note', and therefore the file name '20250718-202345-my-new-note.md'
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
			return tostring(os.date("%Y%m%d-%H%M%S")) .. "-" .. suffix
		end,
		attachments = {
			-- The default folder to place images in via `:ObsidianPasteImg`.
			-- If this is a relative path it will be interpreted as relative to the vault root.
			-- You can always override this per image by passing a full path to the command instead of just a filename.
			folder = "assets/imgs", -- This is the default
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
		ui = {
			enable = false,
		},
	},
	config = function(_, opts)
		local workspaces = {}
		local vaults_config_path = vim.fn.expand("$HOME/.vaults")

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

		require("obsidian").setup(vim.tbl_extend("keep", opts, { workspaces = workspaces }))

		-- This will ensure that changes to buffers are saved when you navigate away from that buffer, e.g. by following a link to another file
		vim.api.nvim_create_autocmd("BufLeave", { pattern = "*.md", command = "silent! wall" })

		-- Replaced mappings
		-- vim.keymap.set({ "n" }, "gf", function()
		-- 	return require("obsidian").util.gf_passthrough()
		-- end, { noremap = true, silent = true, desc = "Open links in browser" })

		vim.keymap.set(
			{ "n", "v" },
			"<leader>n.",
			"<cmd>Obsidian toggle_checkbox<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [.]Toggle Checkbox" }
		)

		vim.keymap.set(
			{ "n", "v" },
			"<leader>nn",
			"<cmd>Obsidian new<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [N]ew note" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>no",
			"<cmd>Obsidian open<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [O]pen note" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>nr",
			"<cmd>Obsidian rename<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [R]ename this note with all backlinks" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>nq",
			"<cmd>Obsidian quick_switch<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [Q]uick switch to another note" }
		)

		vim.keymap.set(
			{ "n" },
			"<leader>nb",
			"<cmd>Obsidian backlinks<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Search all [B]acklinks" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>nt",
			"<cmd>Obsidian tags<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Search and modify [T]ags" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>ns",
			"<cmd>Obsidian search<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [S]earch" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>sn",
			"<cmd>Obsidian search<cr>",
			{ noremap = true, silent = true, desc = "[S]earch [N]otes" }
		)

		vim.keymap.set(
			{ "n" },
			"<leader>nw",
			"<cmd>Obsidian workspace<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Switch [W]orkspace folder" }
		)

		-- Link manipulation
		vim.keymap.set({ "n", "v" }, "<leader>nle", "<cmd>Obsidian extract_note<cr>", {
			noremap = true,
			silent = true,
			desc = "[N]ote [L]inks: [E]xtract text into a new note and link to it",
		})
		vim.keymap.set(
			{ "n" },
			"<leader>nls",
			"<cmd>Obsidian links<cr>",
			{ noremap = true, silent = true, desc = "[N]ote [L]inks: [S]earch all links in the current note" }
		)
		vim.keymap.set({ "n", "v" }, "<leader>nln", "<cmd>Obsidian link_new<cr>", {
			noremap = true,
			silent = true,
			desc = "[N]ote [L]inks: Create [N]ew note and link it",
		})
		vim.keymap.set({ "n", "v" }, "<leader>nll", "<cmd>Obsidian link<cr>", {
			noremap = true,
			silent = true,
			desc = "[N]ote [L]inks: Insert [L]ink to a note",
		})

		vim.keymap.set(
			{ "n" },
			"<leader>nd",
			"<cmd>Obsidian quick_switch todo<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Open the [T]odo note" }
		)

		-- Dailies
		vim.keymap.set(
			{ "n" },
			"<leader>nD",
			"<cmd>Obsidian dailies<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Create/Open [D]aily notes" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>ny",
			"<cmd>Obsidian yesterday<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [Y]esterday's daily note" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>nY",
			"<cmd>Obsidian tomorrow<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: [T]omorrow's daily note" }
		)

		vim.keymap.set(
			{ "n" },
			"<leader>ni",
			"<cmd>Obsidian paste_img<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Paste [I]mage" }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>nc",
			"<cmd>Obsidian toc<cr>",
			{ noremap = true, silent = true, desc = "[N]otes: Open table of [C]ontent" }
		)
	end,
}
