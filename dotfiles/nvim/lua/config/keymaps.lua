-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" })

-- Window navigation with arrow keys after <leader>w
vim.keymap.set("n", "<leader>w<Up>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<leader>w<Down>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<leader>w<Left>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<leader>w<Right>", "<C-w>l", { desc = "Go to right window" })
