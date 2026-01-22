-- Install lazy.nvim to manage plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'Ferouk/bearded-nvim',
        name = 'bearded',
        priority = 1000,
        build = function()
        -- Generate helptags so :h bearded-theme works
        local doc = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy', 'bearded', 'doc')
            pcall(vim.cmd, 'helptags ' .. doc)
        end,
        config = function()
            require('bearded').setup({
                flavor = 'monokai-black', -- any flavor slug
            })
            vim.cmd.colorscheme('bearded')
        end,
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- optional but highly recommended for icons
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require('neo-tree').setup({
                filesystem = {
                    follow_current_file = { enabled = true },
                    filtered_items = {
                        hide_dotfiles = false, -- Show hidden files like .gitignore
                    },
                },
            })
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({})
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    component_separators = '|',
                    section_separators = '',
                    sections = {
                        lualine_a = { 'branch' }
                    }
                }
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs   = require('nvim-treesitter')

            configs.setup({
                ensure_installed = { 'lua', 'rust', 'zig', 'c', 'cpp', 'python', 'vimdoc', 'javascript', 'typescript' },
                sync_install = false,
                highlight = { 
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = { 'rust_analyzer', 'lua_ls', 'zls' }
            })

            -- 1. Configure the server (The 'New' Way)
            vim.lsp.config('rust_analyzer', {
                settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = { command = 'check' },
                        procMacro = { enable = true },
                        -- Add your specific Rust tweaks here
                    }
                }
            })

            -- 2. Enable the server
            vim.lsp.enable('rust_analyzer')
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('zls')
        end
    }
})

