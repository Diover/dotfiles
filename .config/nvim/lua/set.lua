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
vim.opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

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
vim.opt.signcolumn = "yes"  -- show sign column so that text doesn't shift
vim.opt.termguicolors = true

vim.opt.scrolloff = 8

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'
-- faster completion
vim.opt.updatetime = 50

-- scroll settings
vim.opt.foldcolumn = '1'    -- '0' is not bad
vim.opt.foldlevel = 99      -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldenable = true   -- Enable folding

-- Avoid comments to continue on new lines
vim.opt.formatoptions = vim.o.formatoptions:gsub('cro', '')

-- Set foldmethod to expr
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.cmd('colorscheme tokyonight')
