local opt = vim.opt

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
opt.expandtab = true          -- Use spaces instead of tabs
opt.tabstop = 4               -- Tab display width
opt.shiftwidth = 4            -- Indent width for >> and <<
opt.softtabstop = 4           -- Tab width when editing
opt.autoindent = true         -- Copy indent from current line
opt.smartindent = true        -- Smart auto indenting
-- File Handling
opt.autoread = true           -- Reload files changed outside vim
opt.hidden = true             -- Allow swithing buffers without saving
opt.backup = false            -- Don't create backup files
opt.swapfile = false          -- Don't create swap files
opt.undolevels = 10000        -- Maximum undo levels
-- Performance & Behavior
opt.updatetime = 250          -- Faster completion
opt.timeoutlen = 500          -- Key sequence timeout
-- Clipboard & Mouse
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a"               -- Enable mouse in all modes
-- Scrolling & Windows
opt.scrolloff = 8             -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8         -- Keep 8 columns left/right of cursor
opt.splitbelow = true         -- New horizontal splits below
opt.splitright = true         -- New vertical splits to right
-- Status and command line
opt.laststatus = 3            -- Global statusline
opt.cmdheight = 1

