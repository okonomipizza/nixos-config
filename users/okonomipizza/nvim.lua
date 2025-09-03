-- Neovim Configuration
local opt = vim.opt

------------------------------------------------
--- Options
------------------------------------------------
-- Leader key
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
-- Display
opt.number = true
opt.relativenumber = true
opt.showcmd = true
opt.wrap = false
-- Search & Navigation
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.wrapscan = true
-- Indentation & Formatting
opt.expandtab = true	-- Use spaces instead of tabs
opt.tabstop = 4		-- Tab display width
opt.shiftwidth = 4	-- Indent width for >> and <<
opt.softtabstop = 4	-- Tab width when editing
opt.autoindent = true	-- Copy indent from current line
opt.smartindent = true	-- Smart auto indenting
-- File Handling
opt.autoread = true	-- Reload files changed outside vim
opt.hidden = true	-- Allow swithing buffers without saving
opt.backup = false	-- Don't create backup files
opt.swapfile = false	-- Don't create swap files
opt.undolevels = 10000	-- Maximum undo levels
-- Performance & Behavior
opt.updatetime = 250	-- Faster completion
opt.timeoutlen = 500	-- Key sequence timeout
-- Clipboard & Mouse
opt.clipboard = "unnamedplus"	-- Use system clipboard
opt.mouse = "a"			-- Enable mouse in all modes
-- Scrolling & Windows
opt.scrolloff = 8	-- Keep 8 lines above/below cursor
opt.sidescrolloff = 8	-- Keep 8 columns left/right of cursor
opt.splitbelow = true   -- New horizontal splits below
opt.splitright = true	-- New vertical splits to right
-- Status and command line
opt.laststatus = 3      -- Global statusline
opt.cmdheight = 1


------------------------------------------------
--- Keymaps
------------------------------------------------
local keymap = vim.keymap.set

require("nvim-tree").setup()
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
keymap({"n", "t"}, "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap({"n", "t"}, "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap({"n", "t"}, "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap({"n", "t"}, "<C-l>", "<C-w>l", { desc = "Go to right window" })

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

keymap("n", "<leader>tb", function () open_terminal_below(15) end, { desc = "Terminal below" })
keymap("n", "<leader>tr", function () open_terminal_right(80) end, { desc = "Terminal below" })
keymap("t", "<ESC>", "<C-\\><C-n>", {desc = "Terminal: normal mode" })

------------------------------------------------
--- Language Servers
------------------------------------------------

-- diagnostic
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      -- shows message (LSP: rule)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- nvim-lspconfig
local lua_ls_opts = { cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    settings = {
        Lua = {
            diagnostics = {
                unusedLocalExclude = { '_*' },
                globals = { 'vim' }
            }
        }
    }
}
vim.lsp.config('lua_ls', lua_ls_opts)
vim.lsp.enable('lua_ls')

local zig_opts = {
    cmd = { 'zls' },
    filetypes = { 'zig' },
    root_markers = { {'build.zig', 'build.zig.zon'}, '.git' },
    single_file_support = true,
}
vim.lsp.config('zls', zig_opts)
vim.lsp.enable('zls')

-- rust
local rust_opts = {
root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
    single_file_support = true,
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
            },
            procMacro = {
                enable = true,
            },
            diagnostics = {
                enable = true,
            },
            completion = {
                callable = {
                    snippets = "fill_arguments",
                },
            },
        },
    },
}
vim.lsp.config('rust_analyzer', rust_opts)
vim.lsp.enable('rust_analyzer')
------------------------------------------------
--- Plugins
------------------------------------------------
-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    }
}

-- blink.cmp
require('blink.cmp').setup({
    completion = {
        menu = { border = 'single' },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = 'single' },
        },
    },
    signature = {
        window = { border = 'single' },
    },
    keymap = {
        preset = 'none',
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide' },
            ['<CR>'] = { 'accept', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
})

-- Colorscheme
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    theme = "wave",              -- Load "wave" theme
    background = {               -- map the value of 'background' option to a theme
        dark = "dragon",
        light = "lotus"
    },
})
vim.cmd("colorscheme kanagawa")


require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox_dark',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
