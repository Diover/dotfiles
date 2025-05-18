return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require('neogit').setup({})

    vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>')
    vim.keymap.set('n', '<leader>gd', function()
      if next(require('diffview.lib').views) == nil then
        vim.cmd('DiffviewOpen')
      else
        vim.cmd('DiffviewClose')
      end
    end)
    vim.keymap.set('n', '<leader>gl', '<cmd>Neogit log<CR>')
    vim.keymap.set('n', '<leader>gp', '<cmd>Neogit pull<CR>')
    vim.keymap.set('n', '<leader>gP', '<cmd>Neogit push<CR>')
  end
}
