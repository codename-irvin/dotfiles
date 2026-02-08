vim.g.mapleader = ' '

local keymap = vim.keymap.set

-- Neotree keybinding
keymap('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle File Explorer' })

-- Telescope keybindgs
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep, { desc = 'Search Text' })

-- Buffer navigation
keymap('n', 'ga', ':bprevious<CR>', { desc = 'Previous Buffer' })

-- LSP-related bindings
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        local keymap = vim.keymap.set
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Standard LSP Bindings
        keymap('n', 'gd', vim.lsp.buf.definition, opts)
        keymap('n', 'gk', vim.lsp.buf.hover, opts)
        keymap('n', '<leader>r', vim.lsp.buf.rename, opts)
        keymap('n', '<leader>.', vim.lsp.buf.code_action, opts)
        keymap('n', 'gl', vim.diagnostic.open_float, opts)

        -- Completion logic
        if client and client:supports_method('textDocument/completion') then
            -- 1. Enable the new 0.11 completion engine
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })

            -- 2. Use the "Omnifunc" trigger for <C-Space>
            -- This is the most stable way to manually invoke the 0.11 UI
            keymap('i', '<C-Space>', '<C-x><C-o>', opts)
        end

        if client and client:supports_method('textDocument/inlayHint') then
            -- Enable them for the current buffer
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
    end,
})

