-- see :h for each option
vim.g.mapleader = " "
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shortmess = "Iat"
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.showmode = false
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.linebreak= true
vim.opt.breakindent= true
vim.opt.showbreak = "> "
vim.opt.textwidth = 140
vim.opt.termguicolors = true
vim.opt.listchars = {trail = '~', tab = '▸ '}

-- Fast save
vim.keymap.set('n', '<Leader>w', ':w<CR>')
-- Fast quit
vim.keymap.set('n', '<Leader>q', ':q!<CR>')
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

vim.cmd "packadd packer.nvim"

-- Cf. https://neovimcraft.com/
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-fugitive' -- TODO replace by Lua equivalent one fine day, maybe neogit
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'p00f/nvim-ts-rainbow'
    use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim'}
    use 'hrsh7th/nvim-cmp' -- TODO add a snippet engine one fine day
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'tpope/vim-dispatch' -- TODO replace by Lua equivalent one fine day
    use 'jedi2610/nvim-rooter.lua'
    use 'phaazon/hop.nvim' -- TODO lightspeed.nvim and leap.nvim seem reasonable competitors ... converge to whatever plugin comes out successfully from this
    use 'williamboman/nvim-lsp-installer'
    use 'neovim/nvim-lspconfig'
end)
-- TODO Install neorg once it reached 1.0 and comes with better
--      documentation & tutorials, alternatively: nvim-orgmode (but needs
--      more community engagement)

-- Gruvbox is a popular and widely ported color theme.
vim.opt.background = "dark" -- light
vim.cmd "colorscheme gruvbox" -- TODO: set using Lua one fine day
vim.api.nvim_set_hl(0, 'NonText', {fg="#83a598"})
vim.cmd "highlight link markdownError Normal" -- fix another glitch, TODO: use Lua

require('Comment').setup()

require('nvim-autopairs').setup()

require('nvim-rooter').setup {
    rooter_patterns = {'=src'}
}

require'hop'.setup()
vim.keymap.set('n', 'f', ':HopWord<CR>')

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {enable = true},
    incremental_selection = {enable = true},
    -- indent = {enable = true}, -- currently experimental
    rainbow = {enable = true}
}

-- Install LSP servers from within nvim, check the status with :LspInfo and
-- :LspInstallInfo
local lsp_installer = require("nvim-lsp-installer")
local is_found, server = lsp_installer.get_server("clangd")
if is_found and not server:is_installed() then
    server:install()
end

-- Disable messages in sign column by LSP plugin, virtual text does the job
-- nicely
vim.diagnostic.config({signs = false})

-- Keymaps to expose some LSP features, many other functions are available ...
vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 's', vim.lsp.buf.definition)
vim.keymap.set('n', 'S', ':ClangdSwitchSourceHeader<CR>')
vim.keymap.set('v', '<Leader>f', vim.lsp.buf.range_formatting)
vim.keymap.set('n', '<Leader>F', vim.lsp.buf.formatting)
vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_next)

-- Not clear what happens below but that step is recommended
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
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
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
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

require "telescope".setup {
  defaults = {
    preview = false
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
vim.keymap.set('n', '<Leader>l', require('telescope.builtin').live_grep)

-- Configure makeprg. Error format is automatically chosen depending on the
-- filetype, e.g. .cpp --> GCC error format. Use :Make (provided by
-- vim-dispatch) to trigger a build. The relative directory works because
-- nvim-rooter automatically sets the working directory to the source root
-- directory.
vim.cmd [[set makeprg=cd\ ../build;\ ninja]]
-- Shortcuts to step through the quickfix list
vim.keymap.set("n", "<C-j>", ":cnext<CR>")
vim.keymap.set("n", "<C-k>", ":cprevious<CR>")
