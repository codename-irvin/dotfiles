vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Neotree keybinding
keymap("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle File Explorer" })

-- Telescope keybindgs
vim.keymap.set('n', '<leader>ff', require("telescope.builtin").find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', require("telescope.builtin").live_grep, { desc = "Search Text" })

