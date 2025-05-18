-- For a good starting point, see
--   - https://github.com/nvim-lua/kickstart.nvim/
--   - https://www.youtube.com/playlist?list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft

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
vim.opt.wildignorecase = true
vim.opt.mouse = '' -- double-clicking text to copy it has weird work boundaries
vim.opt.completeopt = {'menu', 'menuone', 'noselect'} -- recommended by nvim-cmp
-- vim.opt.cmdheight = 0 -- v0.8: nice but forces to press <enter> too often

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
-- Make (un)indentation repeatable, obsoleted by mini.move
-- vim.keymap.set('v', '<', '<gv')
-- vim.keymap.set('v', '>', '>gv')
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

local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

--

MiniDeps.add('ellisonleao/gruvbox.nvim')
vim.cmd('colorscheme gruvbox')

require('mini.bracketed').setup()

require('mini.indentscope').setup({
  draw = { animation = function() return 0 end },
  symbol ='│'
})

require('mini.jump2d').setup()

require('mini.misc').setup()
MiniMisc.setup_auto_root()

require('mini.move').setup()

require('mini.pairs').setup()

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
  options = {
    -- content_from_bottom = true,
    use_cache = true,
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

require('mini.icons').setup()

require('mini.surround').setup()

require('mini.trailspace').setup()

-- Remember last cursor position, https://github.com/neovim/neovim/issues/16339
MiniDeps.add('ethanholz/nvim-lastplace')
require('nvim-lastplace').setup()

MiniDeps.add('FabijanZulj/blame.nvim')
require('blame').setup()

MiniDeps.add('hiphish/rainbow-delimiters.nvim')

MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    highlight = { enable = true },
})

MiniDeps.add({
    source = 'neovim/nvim-lspconfig',
    -- TODO: migrate to LSP Zero one fine day
    -- TODO: migrate to mini.completion?
    depends = {'hrsh7th/nvim-cmp',
               'hrsh7th/cmp-buffer',
               'hrsh7th/cmp-nvim-lsp',
               'hrsh7th/cmp-nvim-lsp-signature-help'
               -- 'williamboman/mason-lspconfig.nvim',
               -- 'williamboman/mason.nvim'
}})

MiniDeps.add({source = 'williamboman/mason.nvim', checkout = 'v1.11.0'})
MiniDeps.add({source = 'williamboman/mason-lspconfig.nvim', checkout = 'v1.32.0'})

-- They somehow destroyed Mason:
-- See https://github.com/mason-org/mason-lspconfig.nvim/issues/545

-- Install LSP servers from within nvim, check the status with :LspInfo and :LspInstallInfo
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'clangd' },
    automatic_installation = true
})

-- Keymaps to expose some LSP features, many other functions are available ...
local function on_attach(_, bufnr)
    local opts = { buffer = bufnr }
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- neovim 0.10 sets this by default
    vim.keymap.set('n', 's', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 't', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'S', ':ClangdSwitchSourceHeader<CR>', opts)
    vim.keymap.set('n', 'R', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next, opts)
end

-- Advertise capabilities to LSP server
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Disable messages in sign column by LSP plugin, virtual text does the job nicely
vim.diagnostic.config({signs = false})

require('lspconfig')['clangd'].setup({
    on_attach = on_attach,
    capabilities = capabilities
})

-- Note from https://clangd.llvm.org/installation.html:
-- "clangd will look in the parent directories of the files you edit looking
-- for it, and also in subdirectories named build/. For example, if editing
-- $SRC/gui/window.cpp, we search in $SRC/gui/, $SRC/gui/build/, $SRC/,
-- $SRC/build/,"
-- If this becomes too annoying, we could pass --compile-commands-dir=<string>
-- to clangd above (--> "cmd")

local check_backspace = function()
    local col = vim.fn.col '.' - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
end

local cmp = require 'cmp'
cmp.setup({
    -- The order controls the preference for specific sources
    sources = {
        {name = 'nvim_lsp'},
        {name = 'nvim_lsp_signature_help'},
        {name = 'buffer'}
    },
    mapping = {
        -- Overload tab for a natural completion experience
        ['<Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- elseif check_backspace() then
          --   fallback()
          else
            fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
    },
})
