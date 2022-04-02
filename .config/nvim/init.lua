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
vim.opt.termguicolors = true
vim.opt.listchars = {trail = '~', tab = '▸ '}

vim.cmd "nnoremap <Leader>w :w<CR>"
vim.cmd "nnoremap <Leader>q :q!<CR>"
vim.cmd "nnoremap <Leader>d :bd<CR>"
vim.cmd "nnoremap <Leader><Leader> :b#<CR>"

vim.cmd "nnoremap <esc> :noh<return><esc>"

vim.cmd "nnoremap vv V"
vim.cmd "vnoremap < <gv"
vim.cmd "vnoremap > >gv"
vim.cmd "nnoremap n nzz"
vim.cmd "nnoremap N Nzz"
vim.cmd "nnoremap * *zz"
vim.cmd "nnoremap # *zz"
vim.cmd "nnoremap <C-o> <C-o>zz"
vim.cmd "nnoremap <C-i> <C-i>zz"

-- Sanitize behavior of "k" and "j" in wrapped lines
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", {noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", {noremap = true, expr = true, silent = true})

-- TODO convert keymappings to lua one fine day, of today, only ugly APIs
-- vim.api.nvim_set_keymap and vim.api.nvim_buf_set_keymap are available
-- Cf. https://github.com/neovim/neovim/pull/16591 (neovim 0.7+)

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
    use 'phaazon/hop.nvim'
    use 'williamboman/nvim-lsp-installer'
    use 'neovim/nvim-lspconfig'
end)
-- TODO Install neorg once it reached 1.0 and comes with better
--      documentation & tutorials, alternatively: nvim-orgmode (but needs
--      more community engagement)
-- TODO Look into indent-blankline.nvim 

vim.opt.background = "dark"
vim.cmd "colorscheme gruvbox" -- TODO: set using Lua one fine day
vim.cmd "highlight NonText gui=NONE guifg=#83a598"

require('Comment').setup()

require('nvim-autopairs').setup()

require('nvim-rooter').setup {
    rooter_patterns = {'=src'}
}

require'hop'.setup()
vim.cmd "map f <cmd>HopWord<CR>"

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {enable = true},
    incremental_selection = {enable = true},
    -- indent = {enable = true}, -- currently experimental
    rainbow = {enable = true}
}

-- Check the status with :LspInfo and :LspInstallInfo
local lsp_installer = require("nvim-lsp-installer")
local is_found, server = lsp_installer.get_server("clangd")
if is_found and not server:is_installed() then
    server:install()
end

vim.diagnostic.config({signs = false})

vim.cmd "nnoremap <leader>r :lua vim.lsp.buf.rename()<CR>"
vim.cmd "nnoremap K :lua vim.lsp.buf.hover()<CR>"
vim.cmd "nnoremap s :lua vim.lsp.buf.definition()<CR>"
vim.cmd "nnoremap S :ClangdSwitchSourceHeader<CR>"
vim.cmd "nnoremap <leader>f :lua vim.lsp.buf.formatting()<CR>"
vim.cmd "nnoremap <C-n> :lua vim.diagnostic.goto_prev()<CR>"
vim.cmd "nnoremap <C-p> :lua vim.diagnostic.goto_next()<CR>"
-- many other functions are available, maybe another day ...

-- not clear atm what it does but recommended
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}
-- https://clangd.llvm.org/installation.html:
-- "clangd will look in the parent directories of the files you edit looking for it, and also in subdirectories named build/. For example, if editing $SRC/gui/window.cpp, we search in $SRC/gui/, $SRC/gui/build/, $SRC/, $SRC/build/,"
-- If this becomes too annoying, we could pass --compile-commands-dir=<string> to clangd

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local cmp = require 'cmp'
cmp.setup {
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'}
    },
    mapping = {
        -- Snippet stolen from kickstart.nvim
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

vim.cmd "nnoremap <leader>e <cmd>Telescope git_files theme=ivy previewer=false<cr>"
vim.cmd "nnoremap <leader>b <cmd>Telescope buffers theme=ivy previewer=false<cr>"
vim.cmd "nnoremap <leader>l <cmd>Telescope live_grep theme=ivy previewer=false<cr>"

-- Configure makeprg. Error format is automatically chosen depending on the
-- filetype, e.g. .cpp --> GCC error format. Use :Make (provided by
-- vim-dispatch) to trigger a build. The relative directory works because
-- nvim-rooter automatically sets the working directory to the source root
-- directory.
vim.cmd [[set makeprg=cd\ ../build-debug;\ ninja]]
-- Shortcuts to step through the quickfix list
vim.cmd "map <C-j> :cnext<CR>"
vim.cmd "map <C-k> :cprevious<CR>"

-- TODO Fix underscore _ having red hightlighting, e.g. in hover
