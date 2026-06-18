return {
    {
        "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  config = function()
    -- New 0.12 API: no more .configs in the require path
    require("nvim-treesitter.config").setup({
      -- A list of parser names, or "all"
      ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline",
      "python", "svelte", "html", "css", "javascript", "typescript"},
      
      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true, -- 0.12 core handles this, but the plugin adds extra features
        additional_vim_regex_highlighting = false,
      },
      
      indent = {
        enable = true 
      },

      -- Built-in in 0.12, but still configurable here for custom keys
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
    },


    --Themes
    {"ellisonleao/gruvbox.nvim", priority = 1000, config = true},
    {"neanias/everforest-nvim", priority = 1000, config = function()
        require("everforest").setup({}) end},
    {"AlexvZyl/nordic.nvim", lazy = false, priority = 1000, config = function()
        require("nordic").load()
    end},
}
