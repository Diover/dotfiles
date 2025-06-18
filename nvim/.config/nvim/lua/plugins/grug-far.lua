local function get_default_unless_from_oil(default)
	if vim.bo.filetype == "oil" then
		return nil
	end
	return default
end

local function get_cwd_from_oil_or_default(default)
	if vim.bo.filetype == "oil" then
		local oil = require("oil")
		local oil_cwd = oil.get_current_dir()
		if oil_cwd then
			return oil_cwd
		end
	end
	return default
end

return {
	"MagicDuck/grug-far.nvim",
	-- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
	-- additional lazy config to defer loading is not really needed...
	config = function(_, opts)
		require("grug-far").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("my-grug-far-custom-keybinds", { clear = true }),
			pattern = { "grug-far" },
			callback = function()
				vim.keymap.set({ "n", "i" }, "<C-f>", function()
					require("grug-far").get_instance():toggle_flags({ "--fixed-strings" })
				end, { buffer = true })
				vim.keymap.set({ "n", "i" }, "<C-c>", function()
					require("grug-far").get_instance():toggle_flags({ "--ignore-case" })
				end, { buffer = true })
				vim.keymap.set({ "n", "i" }, "<C-h>", function()
					require("grug-far").get_instance():toggle_flags({ "--hidden" })
				end, { buffer = true })
			end,
		})
	end,
	opts = {
		prefills = {
			flags = "--hidden",
			filesFilter = "!.git/",
		},
	},
	keys = {
		{
			"<leader>sr",
			function()
				local grug = require("grug-far")
				grug.open({
					prefills = {
						paths = get_cwd_from_oil_or_default(vim.fn.expand("%")),
						search = get_default_unless_from_oil(vim.fn.expand("<cword>")),
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Grug-far: [S]earch and [r]eplace in current file",
		},
		{
			"<leader>sR",
			function()
				local grug = require("grug-far")
				grug.open({
					prefills = {
						paths = get_cwd_from_oil_or_default(nil),
						search = get_default_unless_from_oil(vim.fn.expand("<cword>")),
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Grug-far: [S]earch and [R]eplace in all files",
		},
		{
			"<leader>s/",
			function()
				local search = vim.fn.getreg("/")
				-- surround with \b if "word" search (such as when pressing `*`)
				if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
					search = "\\b" .. search:sub(3, -3) .. "\\b"
				end
				require("grug-far").open({
					prefills = {
						search = search,
						paths = get_cwd_from_oil_or_default(nil),
					},
				})
			end,
			mode = { "n", "x" },
			desc = "Grug-far: [S]earch and replace using @/ register [/] value or visual selection",
		},
	},
}
