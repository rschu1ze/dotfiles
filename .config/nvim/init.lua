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

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup plug-ins
require("lazy").setup({
    spec = {
        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            config = function()
                vim.o.background = "dark" -- "light" for other theme
                vim.cmd("colorscheme gruvbox")
            end
        },
        {
            "echasnovski/mini.nvim",
            config = function()
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
            end
        },
        -- UTTERLY BROKEN .. I tab-select some file, press <Enter>, and some other file is opened. UNUSABLE.
        -- {
        --     -- TODO One fine day, check snacks.picker
        --     "ibhagwan/fzf-lua",
        --     keys = {
        --         {"<Leader>e", function() require('fzf-lua').files() end, desc = "none" },
        --         {"<Leader>b", function() require('fzf-lua').buffers() end, desc = "none" }
        --     },
        --     opts = {
        --         defaults = {
        --             -- icons are a distraction
        --             file_icons = false,
        --             git_icons = false,
        --             color_icons = false
        --         },
        --         files = {
        --             rg_opts = [[--color=never --files --glob "!.git" --glob "!contrib"]]
        --         },
        --         fzf_opts = {
        --             ["--layout"] = 'default', -- fzf-lua uses "reverse" by default
        --             ["--no-scrollbar"] = true
        --         },
        --         winopts = {
        --             height = 0.4, -- window height
        --             width = 1, -- window width
        --             row = 1, -- window row position (0 = top, 1 = bottom)
        --             col = 0, -- window col position (0 = left, 1 = right)
        --             backdrop = 100, -- don't dim background
        --             preview = {
        --                 hidden = true
        --             }
        --         }
        --     }
        -- },
        {
            "folke/snacks.nvim",
            keys = {
                { "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers" },
                { "<leader>e", function() Snacks.picker.git_files() end, desc = "Explorer" }
            }
        },
        {"ethanholz/nvim-lastplace", opts = {}}, -- https://github.com/neovim/neovim/issues/16339
        {"FabijanZulj/blame.nvim", opts = {}},
        {"hiphish/rainbow-delimiters.nvim"},
        {
            -- Implicitly based on their "master" branch which is frozen.
            -- New development happens in "main" branch.
            -- https://www.reddit.com/r/neovim/comments/1ky0i9q/treesittermodulesnvim_a_reimplementation_of/
            -- https://www.reddit.com/r/neovim/comments/1kuj9xm/has_anyone_successfully_switched_to_the_new/
            -- TODO Switch over when "main" stabilized (the setup seems slightly different)
            "nvim-treesitter/nvim-treesitter",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = "all",
                    highlight = {
                        enable = true
                    },
                })
            end
        },
        {
            'saghen/blink.cmp',
            event = 'VimEnter',
            version = '1.*',
            opts = {
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
            },
        },
        -- From kickstart.nvim
        {
        -- Main LSP Configuration
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            -- Mason must be loaded before its dependents so we need to set it up here.
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            {'mason-org/mason.nvim', opts = {}},
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            {'j-hui/fidget.nvim', opts = {}},

            'saghen/blink.cmp',

            -- :ClangdSwitchSourceHeader
            {'p00f/clangd_extensions.nvim', opts = {}}
        },
        config = function()
          --  This function gets run when an LSP attaches to a particular buffer.
          --    That is to say, every time a new file is opened that is associated with
          --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
          --    function will be executed to configure the current buffer
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
              -- NOTE: Remember that Lua is a real programming language, and as such it is possible
              -- to define small helper and utility functions so you don't have to repeat yourself.
              --
              -- In this case, we create a function that lets us more easily define mappings specific
              -- for LSP related items. It sets the mode, buffer and description for us each time.
              local map = function(keys, func, desc, mode)
                mode = mode or 'n'
                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
              end

              -- Default mappings:
              -- grn - rename
              -- grr - references
              -- K - hover

              -- Extra mappings
              map('s', vim.lsp.buf.definition, '[G]oto [D]efinition')
              map('S', ':ClangdSwitchSourceHeader<CR>', 'Switch header')

              local function client_supports_method(client, method, bufnr)
                  return client:supports_method(method, bufnr)
              end

              -- The following two autocommands are used to highlight references of the
              -- word under your cursor when your cursor rests there for a little while.
              --    See `:help CursorHold` for information about when this is executed
              --
              -- When you move your cursor, the highlights will be cleared (the second autocommand).
              -- local client = vim.lsp.get_client_by_id(event.data.client_id)
              -- if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
              --   vim.api.nvim_create_autocmd('LspDetach', {
              --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              --     callback = function(event2)
              --       vim.lsp.buf.clear_references()
              --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              --     end,
              --   })
              -- end

            end,
          })

          -- Diagnostic Config
          vim.diagnostic.config {
            signs = false,
            virtual_text = true
          }

          -- LSP servers and clients are able to communicate to each other what features they support.
          -- By default, Neovim doesn't support everything that is in the LSP specification.
          -- When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
          -- So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
          local capabilities = require('blink.cmp').get_lsp_capabilities()

          -- Enable the following language servers
          --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
          local servers = {
            clangd = {},
          }

          -- Ensure the servers and tools above are installed
          -- `mason` had to be setup earlier: to configure its options see the
          -- `dependencies` table for `nvim-lspconfig` above.
          local ensure_installed = vim.tbl_keys(servers or {})
          require('mason-tool-installer').setup { ensure_installed = ensure_installed }

          require('mason-lspconfig').setup {
            ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
            automatic_installation = false,
            handlers = {
              function(server_name)
                local server = servers[server_name] or {}
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for ts_ls)
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require('lspconfig')[server_name].setup(server)
              end,
            },
          }
        end,
      },
    }
})
