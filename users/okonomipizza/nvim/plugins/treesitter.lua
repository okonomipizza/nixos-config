require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]s"] = "@scope",
            },
            goto_previous_start = {
                ["[s"] = "@scope",
            },
        },
    },
}
