vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- swapfile settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift
vim.opt.termguicolors = true
vim.g.have_nerd_font = true

vim.opt.scrolloff = 10

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"
-- faster completion
vim.opt.updatetime = 50

-- scroll settings
vim.opt.foldcolumn = "1" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldenable = true -- Enable folding

-- Avoid comments to continue on new lines
vim.opt.formatoptions = vim.o.formatoptions:gsub("cro", "")

-- Set foldmethod to expr
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true
vim.opt.fillchars = vim.opt.fillchars + "diff: "

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local dotfiles_augroup = vim.api.nvim_create_augroup("dotfiles-settings", { clear = true })
-- Highlight when yanking (copying) text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = dotfiles_augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})
-- Close following buffer types with 'q'
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = dotfiles_augroup,
	desc = "Add keymap 'q' to close help/quickfix/netrw/etc windows",
	pattern = "help,startuptime,qf,lspinfo,man,checkhealth,gitsigns-blame,undotree,grug-far",
	callback = function()
		vim.keymap.set("n", "q", "<C-w>c", { buffer = true, desc = "Quit (or Close) help, quickfix, etc windows" })
	end,
})

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
-- Another way could help when <cmd> doesn't work: ":let v:hlsearch = 1 - v:hlsearch<CR>"
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>en", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "[Errors] Go to [N]ext error" })
vim.keymap.set("n", "<leader>ep", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "[Errors] Go to [P]rev error" })

-- Selection movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Yank all, but the cursor at the same position
vim.keymap.set("n", "yY", "mzggyG`z")

-- Join the lines, but keep the cursor at the same position
-- Not super useful at the moment
-- vim.keymap.set("n", "L", "mzJ`z")
-- vim.keymap.set("n", "H", "mzkJ`z")

-- Go to start/end of line
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set({ "n", "v" }, "H", "^")
-- Remove the lines, but keep the cursor at the same position
vim.keymap.set("n", "J", "mzjdd`z")

-- Enter empty lines
vim.keymap.set("n", "<leader>O", "mzO<Esc>`z", { desc = "New line above" })
vim.keymap.set("n", "<leader>o", "mzo<Esc>`z", { desc = "New line below" })

-- Center after scrolling and search
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>")
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>")
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>")
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>")

-- Window resizing
vim.keymap.set("n", "<C-Up>", ":resize -15<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +15<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -15<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +15<CR>")

vim.keymap.set("t", "<C-Up>", "<cmd>resize -15<CR>")
vim.keymap.set("t", "<C-Down>", "<cmd>resize +15<CR>")
vim.keymap.set("t", "<C-Left>", "<cmd>vertical resize -15<CR>")
vim.keymap.set("t", "<C-Right>", "<cmd>vertical resize +15<CR>")

-- Paste without losing the buffer
vim.keymap.set("n", "<leader>p", '"_dP')
vim.keymap.set("i", "<C-p>", "<Esc>p", { desc = "Paste buffer (insert mode), exit to normal mode" })
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- Delete current buffer
vim.keymap.set("n", "<leader>bd", ":bd<CR>")
-- Search and replace word under the cursor
vim.keymap.set("n", "<qeader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])

vim.keymap.set("n", "Q", "<nop>")

-- Write file as sudo
-- This keymap makes typing "w" in the command mode freeze for some reason
-- vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = true, desc = "Write as Sudo" })

--Save without formatting
vim.keymap.set("n", "<leader>wf", ":noautocmd w<CR>", { desc = "Save without [F]ormatting" })

-- Open file explorer
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<cr>")
vim.keymap.set("n", "-", "<cmd>Oil<cr>")
