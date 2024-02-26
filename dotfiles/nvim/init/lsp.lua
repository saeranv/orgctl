-----------------------------------------------------------------------------
--- LSP CONFIG
--- Use LspInfo to debug
--- For LSP installion go to orgmode/auto/setup_env/readme.md
--- warning: lsp module is installed via pip, make sure reflected in 
--- dependencies
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--- MODULES
-----------------------------------------------------------------------------
--- Speeds up lua modules by loading cache of vim plugins
vim.loader.enable()
--- Load plugins
local lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client, bufnr)
    -- this cannot be used w/ nvim-cmp autocomplete
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    
	--- inlay hints
    if client.server_capabilities.inlayHintProvider then 
        vim.g.inlay_hints_visible = true
        vim.lsp.inlay_hint(bufnr, true)
    -- don't need this for all files 
    -- else
    --     print("no inlay hints available")
    end
    
    -- diagnostics
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()

	--- autocmd to show diagnostics on CursorHold
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		desc = "?lsp show diagnostics on CursorHold",
		callback = function()
			local hover_opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always",
				prefix = " ",
			}
			vim.diagnostic.open_float(nil, hover_opts)
		end,
	})
end

---jedi_language_server
lsp.jedi_language_server.setup{
	capabilities = capabilities,
	on_attach = on_attach,
    cmd = { "jedi-language-server" },
    filetypes = {"python"},
    single_file_support = { true },
    settings = {
        jedi = {
            diagnostics = {
                enable = false,
            },
            completion = {
                enable = true,
                fuzzy = true,
                resolve = true,
                -- extraPaths = { "site-packages" },
                disableSnippets = true,
                preloadModules = { 
                    "numpy", "pandas", "matplotlib", "seaborn", "sklearn" 
                },
            },
        },
    },
}
    

lsp.pylsp.setup{
    -- https://github.com/python-lsp/python-lsp-server/tree/develop#configuration
    capabilities = capabilities, 
    on_attach = on_attach,
    filetypes = {"python"},
    cmd = { "pylsp" },
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                jedi_hover = { enabled = true },
                jedi_completion = { fuzzy = true },
                pycodestyle = { 
                    enabled = true,
                    ignore = {
                        'E402', -- E402 imports must be at top of file
                        'E265', -- block comment start, conflicts w/ jukit
                        'E225', 'E231', -- missing whitespace around operator
                        'E702', 'E703', -- multiple statements;
                        'W391', -- blank line at end of file  doesn't work?
                        'W293', -- whitespace on blank line
                        'W291', -- trailing whitespace
                        'E701', -- multiple statements on one line
                        },
                    maxLineLength = 79
                    }, 
                mccabe = { enabled = false }, 
                pyflakes = { enabled = false }, 
                flake8 = { enabled = true }, 
                pylsp_mypy = { enabled = true }, -- for type checking
                },
            },
        },
    }


-- Global mappings
-- in normal mode, t opens float for e[R]rors/diagnostics
vim.keymap.set('n', '<leader>t', vim.diagnostic.open_float)

-- -- in normal mode, t opens float for hover
-- -- Lsp-only mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- normal mode: r opens hover if in lsp-mode(??)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.hover, opts)
  end,
})

-----------------------------------------------------------------------------
--- COPILOT CONFIG
-----------------------------------------------------------------------------
local function accept_word()
    vim.fn['copilot#Accept']("")
    local bar = vim.fn['copilot#TextQueuedForInsertion']()
    return vim.fn.split(bar, [[[ .]\zs]])[1]
end

local function accept_line()
    vim.fn['copilot#Accept']("")
    local bar = vim.fn['copilot#TextQueuedForInsertion']()
    return vim.fn.split(bar, [[[\n]\zs]])[1]
end

vim.g.copilot_no_tab_map = true
vim.g.copilot_node_command = '/home/saeranv/.nvm/versions/node/v20.10.0/bin/node'

vim.keymap.set(
    "i", "qe", 'copilot#Accept("<CR><ESC>")', { silent=true, expr=true }
    )
-- Note: make sure to add 'replace_keycodes=false' Saeran
-- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
-- q b/c similiar position to Tab (same as intellisense completion)
vim.keymap.set('i', 'qw', accept_line, {
    silent=true, expr=true, remap=false, replace_keycodes=false
    })
-- vim.keymap.set('i', 'qr', accept_word, {
--     silent=true, expr=true, remap=false, replace_keycodes=false
-- })

