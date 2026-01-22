vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Neotree keybinding
keymap("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle File Explorer" })

-- Telescope keybindgs
vim.keymap.set('n', '<leader>ff', require("telescope.builtin").find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', require("telescope.builtin").live_grep, { desc = "Search Text" })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        local keymap = vim.keymap.set

        -- Go to Definition
        keymap('n', 'gd', vim.lsp.buf.definition, opts)
        -- Documentation Hover
        keymap('n', 'gk', vim.lsp.buf.hover, opts)
        -- Symbol Rename (Sick refactoring power)
        keymap('n', '<leader>r', vim.lsp.buf.rename, opts)
        -- Show Code Actions (Fix-its)
        keymap('n', '<leader>.', vim.lsp.buf.code_action, opts)
        -- Global Diagnostics (Floating error messages)
        keymap('n', 'gl', vim.diagnostic.open_float, opts)
    end,
})
