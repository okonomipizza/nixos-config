local snacks = require('snacks')

snacks.setup({
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },

    -- pickerのみ有効化
    picker = {
        enabled = true,
    },
    scroll = {
        enabled = true,
        animate = {
            duration = { step = 10, total = 200 },
            easing = "linear",
        },
        animate_repeat = {
            delay = 100, -- 100ms後に高速アニメーションに切り替え
            duration = { step = 5, total = 50 },
            easing = "linear",
        },
        -- どのバッファでアニメーションするか
        filter = function(buf)
            return vim.g.snacks_scroll ~= false
                and vim.b[buf].snacks_scroll ~= false
                and vim.bo[buf].buftype ~= "terminal"
        end,
    },
})

local keymap = vim.keymap.set

-- ファイル検索
keymap('n', '<leader>ff', function() snacks.picker.files() end, { desc = "Find Files" })
keymap('n', '<leader>fr', function() snacks.picker.recent() end, { desc = "Recent Files" })
keymap('n', '<leader>fg', function() snacks.picker.grep() end, { desc = "Live Grep" })
keymap('n', '<leader>fb', function() snacks.picker.buffers() end, { desc = "Buffers" })
keymap('n', '<leader>fw', function() snacks.picker.grep_word() end, { desc = "Grep word" })

-- Git関連
keymap('n', '<leader>gf', function() snacks.picker.git_files() end, { desc = "Git Files" })
keymap('n', '<leader>gs', function() snacks.picker.git_status() end, { desc = "Git Status" })

-- LSP関連
keymap('n', 'gr', function() snacks.picker.lsp_references() end, { desc = "References" })
keymap('n', 'gd', function() snacks.picker.lsp_definitions() end, { desc = "Definitions" })
keymap('n', 'gi', function() snacks.picker.lsp_implementations() end, { desc = "Implementations" })
keymap('n', '<leader>ds', function() snacks.picker.lsp_document_symbols() end, { desc = "Document Symbols" })
keymap('n', '<leader>ws', function() snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace Symbols" })

-- その他
keymap('n', '<leader>fh', function() snacks.picker.help() end, { desc = "Help Pages" })
keymap('n', '<leader>fc', function() snacks.picker.commands() end, { desc = "Commands" })
keymap('n', '<leader>fk', function() snacks.picker.keymaps() end, { desc = "Keymaps" })
