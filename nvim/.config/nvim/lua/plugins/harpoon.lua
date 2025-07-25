return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED
		local harpoon_extensions = require("harpoon.extensions")
		harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

		-- Telescope picker
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon List",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end
		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Open [H]arpoon [L]ist" })

		vim.keymap.set("n", "<leader>sl", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Harpoon: [S]earch in Harpoon [L]ist" })

		-- Main functions
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon: [A]dd current buffer" })

		-- The following layout is based on 6 easily accessible keys on the right hand:
		-- j k l ;
		-- m ,
		-- On the otholinear keyboard these keys are very convenient to reach
		vim.keymap.set("n", "<leader>j", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: go to item 1" })
		vim.keymap.set("n", "<leader>k", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: go to item 2" })
		vim.keymap.set("n", "<leader>l", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: go to item 3" })
		vim.keymap.set("n", "<leader>;", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: go to item 4" })
		vim.keymap.set("n", "<leader>m", function()
			harpoon:list():select(5)
		end, { desc = "Harpoon: go to item 5" })
		vim.keymap.set("n", "<leader>,", function()
			harpoon:list():select(6)
		end, { desc = "Harpoon: go to item 6" })

		-- Same keys, but replacing items instead
		vim.keymap.set("n", "<leader>h<leader>j", function()
			harpoon:list():replace_at(1)
		end, { desc = "Harpoon: go to item 1" })
		vim.keymap.set("n", "<leader>h<leader>k", function()
			harpoon:list():replace_at(2)
		end, { desc = "Harpoon: go to item 2" })
		vim.keymap.set("n", "<leader>h<leader>l", function()
			harpoon:list():replace_at(3)
		end, { desc = "Harpoon: go to item 3" })
		vim.keymap.set("n", "<leader>h<leader>;", function()
			harpoon:list():replace_at(4)
		end, { desc = "Harpoon: go to item 4" })
		vim.keymap.set("n", "<leader>h<leader>m", function()
			harpoon:list():replace_at(5)
		end, { desc = "Harpoon: go to item 5" })
		vim.keymap.set("n", "<leader>h<leader>,", function()
			harpoon:list():replace_at(6)
		end, { desc = "Harpoon: go to item 6" })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<leader>h<Tab>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: go to the next item" })
		vim.keymap.set("n", "<leader>hq", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: go to the previous item" })
	end,
}
