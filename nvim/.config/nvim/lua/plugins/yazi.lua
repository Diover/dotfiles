return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>-",
      function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype == "oil" then
          local dir = require("oil").get_current_dir()
          require("yazi").yazi(nil, dir)
        else
          local file = vim.api.nvim_buf_get_name(buf)
          if file ~= "" then
            require("yazi").yazi(nil, vim.fn.fnamemodify(file, ":h"))
          else
            require("yazi").yazi()
          end
        end
      end,
      desc = "Open yazi at current directory",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      -- NOTE: this requires a version of yazi that includes
      -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
