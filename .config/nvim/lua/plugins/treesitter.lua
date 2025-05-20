return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- Work only within the context of a buffer
  event = { "BufReadPre", "BufNewFile" },
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts

  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = {
      "lua",
      "markdown",
      "luadoc",
      "html",
      "diff",
      "vim",
      "markdown_inline",
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
      "java"
    },

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
    auto_install = true,

    indent = {
      enable = true,
      disable = { "ruby" },
    },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = { "markdown", "ruby" },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        node_decremental = "V",
      },
    }
  }
}
