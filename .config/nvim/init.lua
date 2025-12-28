-- see :h for each option
vim.g.mapleader = ' '
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shortmess = 'Iat'
vim.opt.scrolloff = 6
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.listchars = {trail = '~', tab = '▸ '}
vim.opt.number = true
vim.opt.laststatus = 3
vim.opt.linebreak= true
vim.opt.breakindent= true
vim.opt.showbreak = '> '
vim.opt.textwidth = 140
vim.opt.mouse = '' -- double-clicking text to copy it has weird work boundaries

vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- Fast save
vim.keymap.set('n', '<Leader>w', ':w<CR>')
-- Fast buffer close
vim.keymap.set('n', '<Leader>d', ':bd<CR>')
-- Fast switch to last buffer
vim.keymap.set('n', '<Leader><Leader>', ':b#<CR>')
-- Un-highlight last search result
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<CR>')
-- Make entry into visual mode consistent with cc and dd
vim.keymap.set('n', 'vv', 'V')
-- Center search results + jump list matches
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '*zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
-- More sane behavior of 'k' and 'j' in wrapped lines
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {expr=true})
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", {expr=true})
-- Don't reset the cursor after visual yank
vim.keymap.set('v', 'y', 'ygv<esc>')

-- https://github.com/echasnovski/mini.nvim/issues/124
vim.cmd([[au FileType c lua vim.opt_local.commentstring = '/// %s']])
vim.cmd([[au FileType cpp lua vim.opt_local.commentstring = '/// %s']])
vim.cmd([[au FileType sql lua vim.opt_local.commentstring = '-- %s']])

-- ----------------------------------------------------------------------
-- Plug-ins

vim.pack.add({
    'https://github.com/ellisonleao/gruvbox.nvim',
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/ethanholz/nvim-lastplace',          -- https://github.com/neovim/neovim/issues/16339
    'https://github.com/FabijanZulj/blame.nvim',
    'https://github.com/hiphish/rainbow-delimiters.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range("^1") },
    -- Main LSP Configuration
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/j-hui/fidget.nvim',
})

vim.o.background = 'dark' -- "light" for other theme
vim.cmd.colorscheme('gruvbox')

require("mini.icons").setup()
require("mini.indentscope").setup({
    draw = { animation = require("mini.indentscope").gen_animation.none() }
})
require('mini.misc').setup()
MiniMisc.setup_auto_root()
require('mini.move').setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()
require('mini.pick').setup({
    mappings = {
        -- intentionally disable all other bindings explicitly ...
        caret_left  = '',
        caret_right = '',
        choose            = '<CR>',
        choose_in_split   = '',
        choose_in_tabpage = '',
        choose_in_vsplit  = '',
        choose_marked     = '',
        delete_char       = '<BS>',
        delete_char_right = '',
        delete_left       = '',
        delete_word       = '',
        mark     = '',
        mark_all = '',
        move_down  = '<Tab>',
        move_up    = '<S-Tab>',
        refine        = '';
        refine_marked = '',
        scroll_down  = '',
        scroll_left  = '',
        scroll_right = '',
        scroll_up    = '',
        stop = '<Esc>',
        toggle_info    = '',
        toggle_preview = '',
    },
    window = {
        config = {
            width = 1000, -- max
            height = 10,
        },
    }
})

vim.keymap.set('n', '<Leader>e', function() require('mini.pick').builtin.files() end)
vim.keymap.set('n', '<Leader>b', function() require('mini.pick').builtin.buffers() end)

require('nvim-lastplace').setup{}
require('blame').setup{}

-- local ensure_installed = {
--   "cpp",
--   "sql",
--   "markdown"
-- }
-- require("nvim-treesitter").setup({})
-- require("nvim-treesitter").install(ensure_installed)

require('mason').setup{}
require("mason-lspconfig").setup{
    ensure_installed = { "clangd" }, -- sudo apt install unzip
}

vim.diagnostic.config {
    signs = false,
    virtual_text = true
}

-- Default mappings:
--     grn - rename
--     grr - references
--     K - hover
vim.keymap.set('n', 'S', '<cmd>LspClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', 's', function() vim.lsp.buf.definition() end)

require('blink.cmp').setup{
    keymap = {
        preset = 'default',
        ["<Tab>"] = { "accept", "fallback"}
    },
    completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500
        },
    },
    sources = {
        default = { 'lsp', 'path', 'buffer' }
    },
    signature = {
        enabled = true
    },
    fuzzy = {
        implementation = 'lua'
    },
}
