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
