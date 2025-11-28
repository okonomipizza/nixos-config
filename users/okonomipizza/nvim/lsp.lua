local keymap = vim.keymap.set

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- 定義ジャンプ
        keymap('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Go to definition' })
        keymap('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'Go to declaration' })
        keymap('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = 'Go to implementation' })
        keymap('n', 'gt', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'Go to type definition' })
        keymap('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'Show references' })
        -- ドキュメント表示
        keymap('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Show hover documentation' })
        keymap('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Show signature help' })
        -- リファクタリング
        keymap('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'Rename symbol' })
        keymap({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Code actions' })
        -- フォーマット
        keymap('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, { buffer = ev.buf, desc = 'Format buffer' })
        -- 診断（エラー・警告）ナビゲーション
        keymap('n', '[d', vim.diagnostic.goto_prev, { buffer = ev.buf, desc = 'Go to previous diagnostic' })
        keymap('n', ']d', vim.diagnostic.goto_next, { buffer = ev.buf, desc = 'Go to next diagnostic' })
        keymap('n', '<leader>e', vim.diagnostic.open_float, { buffer = ev.buf, desc = 'Show diagnostic in float' })
        keymap('n', '<leader>q', vim.diagnostic.setloclist, { buffer = ev.buf, desc = 'Open diagnostic quickfix list' })
    end,
})

vim.api.nvim_create_user_command('Efmt', function()
    local filetype = vim.bo.filetype
    if filetype ~= 'erlang' then
        vim.notify('This is not an Erlang file', vim.log.levels.WARN)
        return
    end

    local file = vim.fn.expand('%:p')
    if file == '' then
        vim.notify('No file in buffer', vim.log.levels.WARN)
        return
    end

    local result = vim.fn.system('efmt -w ' .. vim.fn.shellescape(file))
    if vim.v.shell_error == 0 then
        vim.cmd('edit!')
        vim.notify('Formatted with efmt', vim.log.levels.INFO)
    else
        vim.notify('efmt failed: ' .. result, vim.log.levels.ERROR)
    end
end, { desc = 'Format Erlang file with efmt' })


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

-- C / C++
local clangd_opts = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { "compile_commands.json", ".git" },
    single_file_support = true,
    capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), {
        offsetEncoding = { "utf-16" }, -- clangd の補完精度が上がる
    }),
}

vim.lsp.config("clangd", clangd_opts)
vim.lsp.enable("clangd")
-- nvim-lspconfig
local lua_ls_opts = {
    cmd = { 'lua-language-server' },
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
    root_markers = { { 'build.zig', 'build.zig.zon' }, '.git' },
    single_file_support = true,
}
vim.lsp.config('zls', zig_opts)
vim.lsp.enable('zls')

vim.lsp.enable('biome')

local gopls_opts = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.mod', 'go.work', '.git' },
    single_file_support = true,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}
vim.lsp.config('gopls', gopls_opts)
vim.lsp.enable('gopls')

-- Erlang
local erlang_opts = {
    cmd = { 'elp', 'server' },
    filetypes = { 'erlang' },
    root_markers = { 'rebar.config', 'erlang.mk', '.git' },
    single_file_support = true,
    settings = {
        elp = {
            inlayHints = {
                enable = true,
            },
        },
    },
}
vim.lsp.config('elp', erlang_opts)
vim.lsp.enable('elp')


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
