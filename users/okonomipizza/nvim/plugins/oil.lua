local oil = require("oil")

oil.setup({
    keymaps = {
        ["<C-l>"] = "actions.select",
        ["<C-h>"] = { "actions.parent", mode = "n" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
    },
})

-- local keymap = vim.keymap.set
-- keymap('n', '<leader>e', oil.open, { desc = "Open Oil" })
