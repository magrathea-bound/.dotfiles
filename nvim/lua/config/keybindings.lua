--**KeyMaps**--
local opts = {noremap = true, silent = true}
local keymap = vim.keymap.set
local u = require("config.functions")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_user_command("W", "write", {})
keymap("n", "<leader>e", vim.cmd.Ex)

--Easy system clipboard
keymap("n", "<leader>xp", [["+p]])
keymap({"n", "v"}, "<leader>xy", [["+y]])
keymap("n", "<leader>xY", [["+Y]])

--Refresh files
keymap("n", "<Leader>xr", ":checktime<CR>", opts)

--Add Lines 
keymap("n", "<Leader>xo", "o<ESC>k")
keymap("n", "<Leader>xO", "O<ESC>")
keymap("n", "<M-o>", "o<ESC>k")
keymap("n", "<M-O>", "O<ESC>j")

--Seach highlight removal
keymap("n", "<Leader>xh", ":nohlsearch<CR>", {silent = true})

--BufferCommands
keymap("n", "<M-h>", vim.cmd.bprevious)
keymap("n", "<M-l>", vim.cmd.bnext)
keymap("n", "<Leader>bn", vim.cmd.bnext)
keymap("n", "<Leader>bp", vim.cmd.bprevious)
keymap("n", "<Leader>bk", u.Preserve_Window_Bdelete)
keymap({"n", "i"}, "<M-s>", u.toggle_scratch)
keymap("n", "<M-Tab>", "<C-^>", opts)

--Easy window
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

--Misc Commands
vim.keymap.set({"n","v"}, "<Leader>xd", u.remove_duplicate_lines, opts)
vim.keymap.set({"n","v"}, "<Leader>xq", u.format_sql_list, opts)
vim.keymap.set({"n","v"}, "<Leader>xQ", function ()
    u.remove_duplicate_lines()
    u.format_sql_list()
end, opts)
vim.keymap.set("c", "<M-c>", [[\(.*\)]], opts)
vim.keymap.set("c", "<M-C>", [[\(\)<Left><Left>]], opts)

--Some shpiffy Primeagen commands
--https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
--Moves lines up or down and auto indents
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

--Keeps cursor in middle with search
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")


