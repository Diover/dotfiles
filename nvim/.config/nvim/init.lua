-- Per-directory ShaDa file so jumplist/marks stay isolated per project
local cwd = vim.fn.getcwd()
local hash = vim.fn.sha256(cwd):sub(1, 8)
vim.o.shadafile = vim.fn.stdpath("state") .. "/shada/" .. hash .. ".shada"

require("config.lazy")
require("settings")
