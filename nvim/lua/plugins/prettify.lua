return {
    --Themes
    {"ellisonleao/gruvbox.nvim", priority = 1000, config = true},
    {"neanias/everforest-nvim", priority = 1000, config = function()
        require("everforest").setup({}) end},
    {"AlexvZyl/nordic.nvim", lazy = false, priority = 1000, config = function()
        require("nordic").load()
    end},

    {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}

}
