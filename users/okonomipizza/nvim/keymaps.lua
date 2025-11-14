local keymap = vim.keymap.set

keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- Nvim Tree
keymap("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

-- telescope.nvim
local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Window navigation
keymap({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Terminal
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert"
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "term://*",
    command = "startinsert"
})

local function open_terminal_below(height)
    height = height or 15
    vim.cmd('botright split')
    vim.cmd('resize' .. height)
    vim.cmd('terminal')
end

local function open_terminal_right(height)
    height = height or 80
    vim.cmd('botright vsplit')
    vim.cmd('resize' .. height)
    vim.cmd('terminal')
end

keymap("n", "<leader>tb", function() open_terminal_below(15) end, { desc = "Terminal below" })
keymap("n", "<leader>tr", function() open_terminal_right(80) end, { desc = "Terminal below" })
keymap("t", "<ESC>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
