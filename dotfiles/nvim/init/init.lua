-----------------------------------------------------------------------------
-- CHEATSHEET 
-----------------------------------------------------------------------------
-- MODES
-- N:Normal V:Visual O:Operator-pending I:Insert C:Command V:Visual S:Select 
-- nnoremap := N V O 
-- nnoremap!:= I C 
-- inoremap := I 
-- cnoremap := C
-- xnoremap := V (exclusive)
-- snoremap := S (exclusive)
-- KEYMAPS
-- Example in Lua for: nnoremap <silent> <Leader>x iX<ESC>   
--   vim.keymap.set(
--    'n',                  -- n|i|x|...
--    '<Leader>x',          -- keybinding
--    iX<ESC>',             -- operation, can be function? (accept_line)    
--    { silent=true,        -- options   
--      expr=false,         -- - not sure what replace_keycodes does? Nop? 
--      remap=true,            
--      replace_keycodes=false 
--    })
-- FUNCTIONS
-- Use vim.cmd and vim.fn rather than alternativse since the 
-- returned values will be evaled to lua variables, rather then str
-- execute in commandline (:exe 's/^/X/g') 
-- - vim.cmd('s/^/X/g') 
-- to access vim functions (:call winrestview(curr_view))
-- - vim.fn['winrestview'](curr_view)
-- to access shell from vim
-- - vim.fn.system('ls', 'args')
-----------------------------------------------------------------------------
-- CODE HINTS
-- ref: https://neovim.io/doc/user/lua-guide.html
-- to access init.vim scope use : _G variable, i.e. 
-- ??????
-- Variables: 
--   vim.g: global vars
--   vim.b: current buffer vars 
--   vim.w: current window vars 
--   vim.t: current tabpage vars 
--   vim.v: predefined Vim vars 
--   vm.env: variables defined in editor section
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--- KEYBINDINGS
-----------------------------------------------------------------------------
local closure = function (fn, ...)
    -- Create a closure closure for fn that when called 
    -- runs fn w/ args
    local args = {...}
    return function() fn(unpack(args)) end
end

local cmd_resetview = function(cmd_str)
    -- Util to keymap commands w/o losing cursor/view
    local curr_view = vim.fn['winsaveview']()
    vim.cmd(cmd_str)
    vim.fn['winrestview'](curr_view)
end

-- Set leader
vim.g.mapleader = ';'
vim.g.maplocalleader = ';'
vim.keymap.set(
    'n', '<leader>x',
    closure(cmd_resetview, 's/^/X/g|noh'),
    { silent=true, expr=false, remap=true, replace_keycodes=false } 
)
vim.keymap.set(
    'n', '<leader>w',
    closure(cmd_resetview, 's/^/W/g|noh'),
    { silent=true, expr=false, remap=true, replace_keycodes=false } 
)
vim.keymap.set(
    'n', '<leader>dt',
    -- 'i<c-r>=strftime("%H%M")<cr><esc>'
    string.format("i%s<esc>", vim.fn.system('date +\\%H\\%M')),
    { silent=true, expr=false, remap=true, replace_keycodes=false } 
)
vim.keymap.set(
    'n', '<leader>dd',
    -- 'i<c-r>=strftime("%Y%m%d")<cr><esc>'
    string.format(
        "i%s<esc>", 
        vim.fn.system('date +\\%Y\\%m\\%d | sed "s/^..//"')
    ),
    { silent=true, expr=false, remap=true, replace_keycodes=false } 
)

-- -- Adding some syntax sugar on vim-sandwhich
-- vim.keymap.set(
--     'n', '<leader>b', 'bviwS)',    
--     { silent=true, expr=false, remap=true, replace_keycodes=false }
-- )
-- vim.keymap.set(
--     'i', '<leader>b', '<esc>bviwS)<esc>', 
--     { silent=true, expr=false, remap=true, replace_keycodes=false }
-- )
-- vim.keymap.set(
--     'n', '<leader>s', 'bviwS"', 
--     { silent=true, expr=false, remap=true, replace_keycodes=false }
-- )
-- vim.keymap.set(
--     'i', '<leader>s', '<esc>bviwS"<esc>', 
--     { silent=true, expr=false, remap=true, replace_keycodes=false }
-- )


