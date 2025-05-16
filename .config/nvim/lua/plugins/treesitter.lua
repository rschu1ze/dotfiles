return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = { 'cpp', 'c', 'bash', 'lua', 'sql', 'xml', 'python', 'json' },
      highlight = {
        enable = true,
      }
    }
}
