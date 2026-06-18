
--**KeyMaps**--
local opts = {noremap = true, silent = true}
local keymap = vim.keymap.set

keymap("n", "<C-b>", ":bnext<CR>", opts)

--Leader Commands--
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Doc format map leaders
keymap("n", "<leader>xp", [["+p]])
keymap({"n", "v"}, "<leader>xy", [["+y]])
keymap("n", "<leader>xY", [["+Y]])

--Add Lines 
keymap("n", "<Leader>xo", "o<ESC>k")
keymap("n", "<Leader>xO", "O<ESC>j")

--Seach highlight removal
keymap("n", "<Leader>xh", ":nohlsearch<CR>", {silent = true})

--BufferCommands
keymap("n", "<M-h>", vim.cmd.bprevious)
keymap("n", "<M-l>", vim.cmd.bnext)
keymap("n", "<Leader>bn", vim.cmd.bnext)
keymap("n", "<Leader>bp", vim.cmd.bprevious)
keymap("n", "<Leader>bk", vim.cmd.bdelete)

--File Explorer
keymap("n", "<leader>e", vim.cmd.Ex)

--Experimentation on some shpiffy Primeagen commands
--https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
--Moves lines up or down and auto indents
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

--keeps cursor still with J
keymap("n", "J", "mzJ`z")

--Keeps cursor in middle with search
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

--Search and replace for current word 
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

--The real important commands
keymap("n", "<Leader>FF", "<cmd>CellularAutomaton make_it_rain<CR>")

