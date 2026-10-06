--**KeyMaps**--
local opts = {noremap = true, silent = true}
local keymap = vim.keymap.set
local userF = require("config.userFunctions")

--:W to :w
vim.api.nvim_create_user_command("W", "write", {})

--Leader Commands--
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Doc format map leaders
keymap("n", "<leader>xp", [["+p]])
keymap({"n", "v"}, "<leader>xy", [["+y]])
keymap("n", "<leader>xY", [["+Y]])

--Add Lines 
keymap("n", "<Leader>xo", "o<ESC>k")
keymap("n", "<Leader>xO", "O<ESC>")
keymap("n", "<M-o>", "o<ESC>k")
keymap("n", "<M-O>", "O<ESC>j")

--Seach highlight removal
keymap("n", "<Leader>xh", ":nohlsearch<CR>", {silent = true})

--Refresh files
keymap("n", "<Leader>xr", ":checktime<CR>", opts)

--BufferCommands
keymap("n", "<M-h>", vim.cmd.bprevious)
keymap("n", "<M-l>", vim.cmd.bnext)
keymap("n", "<Leader>bn", vim.cmd.bnext)
keymap("n", "<Leader>bp", vim.cmd.bprevious)
keymap("n", "<Leader>bk", userF.Preserve_Window_Bdelete)
keymap("n", "<Leader>bs", vim.cmd.Scratch)
keymap({"n", "i"}, "<M-s>", vim.cmd.Scratch)


--Easy window
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

--Netrw
keymap("n", "<leader>e", vim.cmd.Ex)

--Experimentation on some shpiffy Primeagen commands
--https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
--Moves lines up or down and auto indents
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

--keymap("n", "J", "mzJ`z")
--keeps cursor still with J

--Keeps cursor in middle with search
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

--The real important commands
keymap("n", "<Leader>FF", "<cmd>CellularAutomaton make_it_rain<CR>")

