-- For a good starting point, see. https://github.com/nvim-lua/kickstart.nvim/

-- see :h for each option
vim.g.mapleader = ' '
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shortmess = 'Iat'
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmode = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.laststatus = 3
vim.opt.linebreak= true
vim.opt.breakindent= true
vim.opt.showbreak = "> "
vim.opt.textwidth = 140
vim.opt.termguicolors = true
vim.opt.wildignorecase = true
vim.opt.listchars = {trail = '~', tab = '▸ '}
-- vim.opt.cmdheight = 0 # v0.8: nice but forces to press <enter> too often
vim.opt.mouse = ""

-- Fast save
vim.keymap.set('n', '<Leader>w', ':w<CR>')
-- Fast buffer close
vim.keymap.set('n', '<Leader>d', ':bd<CR>')
-- Fast switch to last buffer
vim.keymap.set('n', '<Leader><Leader>', ':b#<CR>')
-- Un-highlight last search result
vim.keymap.set('n', '<esc>', ':noh<return><esc>')
-- Make entry into visual mode consistent with cc and dd
vim.keymap.set('n', 'vv', 'V')
-- Make (un)indentation repeatable
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
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

-- ----------------------------------------------------------------------
-- Plug-ins

vim.cmd.packadd('packer.nvim')

-- Cf. https://neovimcraft.com/
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'navarasu/onedark.nvim'
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'p00f/nvim-ts-rainbow'
    use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim'}
    use 'lukas-reineke/indent-blankline.nvim'
    use 'hrsh7th/nvim-cmp' -- TODO add a snippet engine one fine day
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'jedi2610/nvim-rooter.lua'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'tpope/vim-fugitive'
    -- TODO install fugitive-like, lua-based Git interface one fine day (the Git command line works just fine for now)
    -- use 'ggandor/leap.nvim' -- clashes with s/S keybinding for LSP
end)
-- TODO Install neorg once it reached 1.0 and comes with better
--      documentation & tutorials, alternatively: nvim-orgmode (but needs
--      more community engagement)
-- TODO Install dap https://www.youtube.com/watch?v=0moS8UHupGc https://www.youtube.com/watch?v=ga3Cas7vNCk https://www.youtube.com/watch?v=SIYt1dopfTc

vim.opt.background = 'dark' -- light
-- Choose one of three popular and widely ported color themes
vim.cmd.colorscheme('gruvbox')
-- vim.cmd.colorscheme('onedark')
-- vim.cmd.colorscheme('nightfox')

-- Special hacks for gruvbox
vim.api.nvim_set_hl(0, 'NonText', {fg='#83a598'})
vim.cmd.highlight('link markdownError Normal') -- fix another glitch

require('Comment').setup()
local ft = require('Comment.ft')
ft.cpp = {'/// %s'}

require('nvim-autopairs').setup()

require('nvim-rooter').setup {
    rooter_patterns = {'=src'}
}

require('indent_blankline').setup {
  char = '⋮',
  char_blankline = '',
  show_first_indent_level = false,
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = 'all',
    highlight = {enable = true},
    incremental_selection = {enable = true},
    -- indent = {enable = true}, -- currently experimental
    rainbow = {enable = true}
}

-- Install LSP servers from within nvim, check the status with :LspInfo and :LspInstallInfo
require('mason').setup {}
require('mason-lspconfig').setup {
    ensure_installed = { 'clangd' },
    automatic_installation = true
}

-- Keymaps to expose some LSP features, many other functions are available ...
local function on_attach(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 's', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'S', ':ClangdSwitchSourceHeader<CR>', opts)
    vim.keymap.set('n', 'R', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_next, opts)
end

-- Disable messages in sign column by LSP plugin, virtual text does the job nicely
vim.diagnostic.config({signs = false})

require('lspconfig')['clangd'].setup {
    on_attach = on_attach,
}

-- Note from https://clangd.llvm.org/installation.html:
-- "clangd will look in the parent directories of the files you edit looking
-- for it, and also in subdirectories named build/. For example, if editing
-- $SRC/gui/window.cpp, we search in $SRC/gui/, $SRC/gui/build/, $SRC/,
-- $SRC/build/,"
-- If this becomes too annoying, we could pass --compile-commands-dir=<string>
-- to clangd above (--> "cmd")

-- Stolen from somewhere I don't remember
local check_backspace = function()
  local col = vim.fn.col '.' - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
end

local cmp = require 'cmp'
cmp.setup {
    -- The order controls the preference for specific sources
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'}
    },
    mapping = {
        -- Overload tab for a natural completion experience
        ['<Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif check_backspace() then
            fallback()
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
}

local actions = require("telescope.actions")

require 'telescope'.setup {
  defaults = {
    preview = false,
    mappings = {
      i = {
        ["<esc>"] = actions.close, -- close on single <esc> press
      },
    },
  },
  pickers = {
    git_files = {
      theme = 'ivy',
    },
    buffers = {
      theme = 'ivy',
      sort_mru = true,
    },
    live_grep = {
      theme = 'ivy',
    }
  },
}

-- Make telescope available via shortcuts
vim.keymap.set('n', '<Leader>e', require('telescope.builtin').git_files)
vim.keymap.set('n', '<Leader>b', require('telescope.builtin').buffers)
vim.keymap.set('n', '<Leader>l', require('telescope.builtin').live_grep) -- requires ripgrep
