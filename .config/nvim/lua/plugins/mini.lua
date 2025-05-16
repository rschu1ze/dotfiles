return {
    'echasnovski/mini.nvim',
    config = function()
        require('mini.icons').setup()
        require('mini.indentscope').setup({
            draw = { animation = function() return 0 end }
        })
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
            window = {
                config = {
                    width = 1000, -- max
                    height = 10,
                },
            }
        })
        vim.keymap.set('n', '<Leader>e', function() require('mini.pick').builtin.files() end)
        vim.keymap.set('n', '<Leader>b', function() require('mini.pick').builtin.buffers() end)
        require('mini.surround').setup()
        require('mini.trailspace').setup()
    end
}
