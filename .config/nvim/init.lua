vim.cmd "packadd packer.nvim"

-- Cf. https://neovimcraft.com/
require('packer').startup(function()
    use {'wbthomason/packer.nvim'}
    use {'ellisonleao/gruvbox.nvim'}
    use {'numToStr/Comment.nvim'}
    use {'windwp/nvim-autopairs'}
    use {'tpope/vim-fugitive'} -- TODO replace by Lua equivalent one fine day, maybe neogit?
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use {'p00f/nvim-ts-rainbow'}
    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}}}
    use {'hrsh7th/nvim-cmp'} -- TODO add a snippet engine one fine day
    use {'hrsh7th/cmp-buffer'}
    -- use {"ahmedkhalf/project.nvim"} -- TODO needed?
    use {'phaazon/hop.nvim'}
    use {'vim-scripts/a.vim'} -- Note: comment imap/nmap block in ~/.local/share/nvim/site/pack/packer/start/a.vim/plugin/a.vim
    -- TODO integrate with LSP
end)

vim.g.mapleader = " "
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autochdir = true
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
vim.opt.termguicolors = true
-- vim.opt.background = "light"
vim.cmd "colorscheme gruvbox" -- TODO: set using Lua one fine day

-- deliberately after the colortheme
vim.cmd "set listchars=trail:~"
vim.cmd "highlight NonText ctermfg=green" -- try to make trailing ~ (belonging to group "NonText") green ... doesn't work :(

-- TODO convert keymappings to lua one fine day, of today, only ugly APIs
-- vim.api.nvim_set_keymap and vim.api.nvim_buf_set_keymap are available
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

vim.cmd "nnoremap <leader>e <cmd>Telescope git_files theme=ivy previewer=false<cr>"
vim.cmd "nnoremap <leader>b <cmd>Telescope buffers theme=ivy previewer=false<cr>"
vim.cmd "nnoremap <leader>l <cmd>Telescope live_grep theme=ivy previewer=false<cr>"

-- require("project_nvim").setup()

require('Comment').setup()

require('nvim-autopairs').setup()

require('hop').setup()
vim.cmd "map f <cmd>HopWord<CR>"

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {enable = true},
    incremental_selection = {enable = true},
    -- indent = {enable = true}, -- currently experimental
    rainbow = {enable = true}
}

local cmp = require'cmp'
cmp.setup {
    sources = {{name = 'buffer'}},
    mapping = {
    -- Snippet stolen from kickstart.nvim
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
}
