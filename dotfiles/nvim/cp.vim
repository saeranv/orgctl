" ----------------------------------------------------------------------------#
" LEGEND:
" DEBUG COMMAND OVERRIDES:
"   ':verbose map sa'; for custom mappings
"                      indicates where mapping was last set (use map!)
"   ':help gg'       ; for built in commands
"   let @+=cmd  OR
"   let @+=exe(cmd)  ; to copy error messages to clipboard
" INSTALL OR UNINSTALL:
"   - :source $MYVIMRC; :PlugInstall
"   - :source $MYVIMRC; :PlugClean
"   - :PlugUpdate, :UpdateRemotePlugins
" VIMSCRIPT:
"   - ! in function overwrites previous function w/ same name
"   - <expr> allows for conditional mapping
"       - nnoremap <expr> {new-key}
"           \ ({condition} ? '{true}' : '{false}')
"   <C-o> runs command in NORMAL mode, then back to insert mode
"   <C-R> inserts result of expression at cursor (see leader v for date)
"   use '|' to run two commands i.e. exe "s/^/x/g \| noh' 
"   VIM MODES:
"   n:normal v:visual o:operator-pending 
"   i:insert c:command v:visual s:select 
"   nnoremap := n v o 
"   nnoremap!:= i c 
"   inoremap := i 
"   cnoremap := c
"   xnoremap := v (exclusive)
"   snoremap := s (exclusive)
" REFS:
" AUTOCOMMANDS: https://vimdoc.sourceforge.net/htmldoc/autocmd.html#autocmd-list
" ---------------------------------------------------------------------------#
call plug#begin('~/.config/nvim/vim_plugins/')
Plug 'navarasu/onedark.nvim'
Plug 'tpope/vim-markdown'
Plug 'github/copilot.vim'
Plug 'svermeulen/vim-cutlass'
Plug 'vimjas/vim-python-pep8-indent'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'dstein64/nvim-scrollview'
" All of this for lspconfig.
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'dstein64/vim-startuptime'
Plug 'christoomey/vim-tmux-navigator'
" For wilder.nvim (autocomplete in cmd mode)
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction
  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'
endif
call plug#end()
" ---------------------------------------------------------------------------#
" STARTUP SHUTDOWN BEHAVIOUR:
" ---------------------------------------------------------------------------#
if !exists("*SrcVimf")
    " Need to define SrcVimf like this or else get errors
    function! SrcVimf()
        " Save states
        let l:curr_reg = getreg('e')
        let l:curr_reg_type = getregtype('e')
        let l:curr_view = winsaveview() 
        exe 'write|source ' . $MYVIMRC
        " Restore states
        call setreg('e', curr_reg, curr_reg_type)
        call winrestview(l:curr_view)
    endfunction
endif
command! SrcVimf :call SrcVimf()
ca src SrcVimf<CR>
if !empty($CONDA_PREFIX)
    let g:python3_host_prog = $CONDA_PREFIX . '/bin/python3'
else
    let g:python3_host_prog = '/home/saeranv/miniconda3/envs/thermal/bin/python3'
endif
" Set custom node path 
" For version v16.20.1 with fnm
" Note: this should be same as the one in lua/lsp.lua for copilot
" If this gives issues, switch to nvm and just add nvm/bin/node to path...
" let g:node_host_prog = '/home/saeranv/.nvm/versions/node/v20.10.0/bin/node'
set termguicolors
set hidden| " saves all open buffers in background
set confirm| " comfirm before overwrite unsaved files
" Period .|,|; repeats last cmd,
" Set all three timeout vars like this, make sure ttimeoutlen is neg
" Then control all timeouts w/ timeoutlen
set ttimeout
set ttimeoutlen=-500
set timeout
set timeoutlen=200
" Or increase timeoutlen Press space after leader to ensure no waiting lag
nnoremap <SPACE> <Nop>
" Sets map leader key is ;
let g:mapleader=';'
set showcmd
" Disable modelines, causing bugs for somereason
set nomodeline
set laststatus=2
" Approximation of default statusline (b/c im can't reset this).
set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)
set mouse=a
" Sets default default tab splits
set splitbelow
set splitright
set directory=/tmp
set backupdir=/tmp
set autowrite
" to get vim terminal to recognize bash env
let &shell='/usr/bin/zsh'
set shellcmdflag=-c
" ignore case when searching
set ignorecase
" smartcase: if search has uppercase, then case sensitive
set smartcase
" ignore case when using wilder for autocomplete
set wildignorecase 
" Cmdline autocomplemete
set fileformat=unix
set nocompatible
set backspace=indent,eol,start
set clipboard+=unnamedplus
" za to toggle fold, zd to remove fold
set foldmethod=manual
set nofoldenable
set foldlevel=3
" display incremental substution %s/foo/bar/g, opts: split/nosplit
set inccommand=split
let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \   },
            \   'cache_enabled': 0,
        \ }
call wilder#setup({
  \ 'modes': [':', '/', '?'],
  \ 'next_key': '<Tab>',
  \ 'previous_key': '<C-Tab>',
  \ 'accept_key': '<Enter>',
  \ 'reject_key': '<C-c>',
  \ })
set wildmenu
" ---------------------------------------------------------------------------#
" SET LINE BEHAVIOUR:
" ---------------------------------------------------------------------------#
filetype indent on
set virtualedit+=onemore
set whichwrap+=h,l
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab|  " use C-v tab for real tab
set smarttab
set number
" Relative number seems to slow down scrolling
" set relativenumber
set noshowmatch|  " Don't set matching brackets
set breakindent| " Maintains indent when wrap lines
set autoindent
set linebreak| " when wrap lines hard/soft, break at word
" Strip trailing white space in python when save
autocmd BufWritePre *.py %s/\s\+$//e
" For speedy vim
" Jump 5 lines down when cursor goes off bottom of screen; used to speed
" up scrolling refrehes. Higher number is faster.
set scrolljump=5
" DISABLED: Number of lines to scroll when using <C-d> or <C-f>;
"  -- disabled b/c causes errors on small tmux splits
"  -- C-d; C-f are used for fzf
" set scroll=15
" Screen won't redrawn for some ops
set lazyredraw
" Makes everything drawn quicker
set ttyfast

" ---------------------------------------------------------------------------#
" CUSTOM KEYBINDINGs:
" Notes:
" register is verb-prefix "<reg><verb><noun>
" set register to a = "a
" yank word to register: "ayw
" paste at cursor: "ap
" paste into cmd line: :<C-r>a
" ---------------------------------------------------------------------------#
let @e = ':!python %:p'
noremap  <silent><leader>e <esc>:write<cr><esc>:<c-r>e<cr>
noremap  <leader>ee <esc>:write<cr><esc>:<c-r>e
" remap recording from normal q (or else constantly triggered)
noremap E q
noremap q <Nop>
" automatic saving highlight:
" q; toggles highlights
" entering command mode, automatically saves file
" in command mode, c-c - cancel commands, goes back
" in command mode, <esc> == enter
" note: qw is doubled up with accept copilot. seems to work
" despite conflict.
noremap <silent> qw :noh<cr>:update<cr>
" this is equivalent to :noh after search when in insert
autocmd InsertEnter * :let @/=""
cnoremap <c-c><c-c> <c-c>:
" keybindings for search
"   - use / to search
"   - use / (in vmode) search in selection
"   - use *|# search forward|backwards (selected or unselected)
"   - c-t  - fzf search current
"   - default commands
"   cmode : ':s/red/green' in vmode find/replace selected area
"   cmode : ':s/red/green/g' for all
vnoremap / <esc>/\%v
" overwrite default behaviour where cmode c-f brings search history
" type :fzf in cmdline to get this working
" let g:fzf_command_prefix = 'Fzf'
" noremap <C-t> <c-o>:FzfBLines<cr>
" search for selected text, forwards or backwards.
" ref: https://vim.fandom.com/wiki/search_for_visually_selected_text
" overwrite nmode <c-g> which brings up filename/currentline
" now it brings up fzf search
nnoremap <c-f> :<up>
xnoremap <c-f> :<up>
cnoremap <c-f> <c-f>
" we replace c-g with <leader>g in nmode: used to bring up
"   filenmae/currentline/postion as % and column number.
"   nmode [count]% scrolls by percent
" to bring up search use / in nmode
nnoremap <leader>g <c-g>
" remap ctrl j/k
"   - cmode: scrolling command history
"   - imode: navigation in command mode
"   - nmode: half page scroll in normal mode
" search word under cursor - forward|backwards *|#
vnoremap <silent> * :<c-u>
  \let old_reg=getreg('"')<bar>let old_regtype=getregtype('"')<cr>
  \gvy/<c-r>=&ic?'\c':'\c'<cr><c-r><c-r>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<cr><cr>
  \gvzv:call setreg('"', old_reg, old_regtype)<cr>
vnoremap <silent> # :<c-u>
  \let old_reg=getreg('"')<bar>let old_regtype=getregtype('"')<cr>
  \gvy?<c-r>=&ic?'\c':'\c'<cr><c-r><c-r>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<cr><cr>
  \gvzv:call setreg('"', old_reg, old_regtype)<cr>
" find/replace substituded text: <c-g> 
" <c-r> pastes 0 (yank register) into command 
vnoremap <c-g> y<esc>:%s/<c-r>0//g<left><left>
" normal-mode navigation
nnoremap <c-j> <c-d>
nnoremap <c-k> <c-u>
" tmuxnav
let g:tmux_navigator_no_mappings = 1
noremap <silent> <C-h> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <C-d> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <C-u> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <C-l> :<C-U>TmuxNavigateRight<cr>
noremap <silent> <C-q> :<C-U>TmuxNavigatePrevious<cr>

" command-mode
cnoremap <c-j> <c-n>
cnoremap <c-k> <c-p>
cnoremap <c-h> <left>
cnoremap <c-l> <right>
" insert mode
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>
" ca abbreviations
ca bw :bw<cr>
ca bd :bdelete<cr>
ca sete :let @e=':'<cr>:<c-f>1h
ca sett :let @e=':!tmux send-keys -t bottom "" enter'<cr>:<c-f>9h
" ---------------------------------------------------------------------------#
" NAVIGATING SPLITS KEYBINDINGS
" ---------------------------------------------------------------------------#
" Buffer navigation
" :ls -> lists all buffers
" Use C-n/C-p to cycle buffers
" ctrl n/p for next previous buffer
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
" Terminal
" <C-w> e toggle: jump to other split pane, anytime
" <C-w> r to exit terminal focus
" <C-w> f to flip the split tabs
" <C-w> h, j k l to navigate splits
tnoremap <C-w>e <C-\><C-N><C-w>w
tnoremap <C-w>r <C-\><C-N>
noremap <C-w>f <C-w>w
" ---------------------------------------------------------------------------#
" REMAP BASICS: MOTION/YANK/NOH
" ---------------------------------------------------------------------------#
" Better line motions
" H: Move to first non-blank char of line
" L: Move to last non-blank char of line
noremap H ^
noremap L g_
" Recommended from help: Y, so Y same as C, D
" Y|C|D yanks from cursor to end of line
map Y y$
nnoremap x vd
xnoremap x d
nnoremap xx dd
nnoremap X D
" Center screen on next/previous selection.
" nnoremap n nzz
" nnoremap N Nzz
" COMMENTARY: use <leader>i<textobject> to apply; <leader>ii takes count
" Remove the default gc keybinding to no-op.
xmap <silent> <leader>i  <Plug>Commentary
" nmap <silent> <leader>i  <Plug>Commentary
nnoremap <silent> <leader>i <Plug>CommentaryLine
noremap gc <Nop>
noremap gcc <Nop>

" ---------------------------------------------------------------------------#
" AESTHETICS
" ---------------------------------------------------------------------------#
set t_Co=256|   " This is may or may not needed.
" HIGHLIGHTING
" This variable needs to be inited
" NOTE: can set this to 0, and then 1 in PythonMode
let python_highlight_all=1
let g:onedark_config = {
    \ 'style': 'deep',
    \ 'toggle_style_key': '<leader>`',
    \ 'toggle_style_list':
    \ ['dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light']
    \}
function! CodeMode()
    " Open coC-settingsjson with :CocConfig
    colorscheme onedark
    " set background=dark  " Careful, will override guibg
    " Shared preferences
    highlight Search    gui=None guibg=red guifg=green
    highlight IncSearch gui=None guibg=red guifg=green
    highlight EndOfBuffer guibg=black
    highlight Normal guibg=black
    highlight Normal guifg=white
    syntax on| " code highlight
    highlight Search    gui=None guifg=gray guibg=green
    highlight IncSearch gui=None guifg=gray guibg=green
    highlight EndOfBuffer guibg=black
    set colorcolumn=79
    set textwidth=79
    highlight ColorColumn ctermbg=DarkRed guibg=DarkRed
    highlight Comment ctermfg=darkgray guifg=darkgray
    " For closing bracket alignment
    let g:python_pep8_indent_multiline_string=-1
    " - multiline str: -1:=keeps exising indent, 0:= no indent
    let g:python_pep8_indent_hang_closing=0
    " - closing: 0: lines up w/ start line, 1: lines up w/ items (indented)
endfunction
command! CodeMode :call CodeMode()
" ---------------------------------------------------------------------------#
" filetypes
" ---------------------------------------------------------------------------#
ca whatft :echo '&filetype (saved): ' .
            \ &filetype . ' extension (real): ' . expand('%:e')<cr>
function SetLocalFileTypeHelper(extension)
    " manually sets localfiletype variable
    if a:extension ==? 'py'
        setlocal filetype=python
    elseif a:extension ==? 'org'
        setlocal filetype=markdown
    elseif a:extension ==? 'lua'
        setlocal filetype=lua
    elseif a:extension ==? 'vim'
        setlocal filetype=vim
    elseif a:extension ==? 'md'
        setlocal filetype=markdown
    elseif a:extension ==? 'json'
        setlocal filetype=json
    elseif a:extension ==? 'osm'
        setlocal filetype=markdown
    elseif a:extension ==? 'osw'
        setlocal filetype=json
    endif
endfunction
function SetLocalFileType()
    " :doautoall filetype
    :call SetLocalFileTypeHelper(expand('%:e'))
endfunction
command! SetLocalFileType :call SetLocalFileType()
" set filetypes, and call codemode
" ref: https://vimdoc.sourceforge.net/htmldoc/autocmd.html#autocmd-list
" bufdo doautocmd filetype
" doautoall filetype
augroup set_modes
    autocmd!
    " to check which filetype vim thinks its on, use command:
    "   :set ft
    " to manuall override autodeteched filetype use:
    "  :setlocal ft=<filetype>
    " BufAdd: after adding buffer to buffer list
    " bufnew: after creating new buffer
    " bufenter: after entering a buffer
    "   - seems to fail if we :write buffer, and then
    "     :bnext/bprevious to enter another buffer
    "     :the next buffer loses formatting
    " bufwinenter: after buffer is displayed in window
    " bufwrite: starting to write whole buffer to file
    " autocmd filetype,bufnew,bufenter,bufwinenter,bufwrite
    "             \*.md,*.org :setlocal filetype=markdown
    " autocmd filetype,bufnew,bufenter,bufwinenter,bufwrite
    "             \*.json,*.osw :setlocal filetype=json
    autocmd Filetype,BufEnter * silent call SetLocalFileType()
    " sets code formatting
    autocmd filetype,BufEnter * silent call CodeMode()
    " sets cwd to current file path
    autocmd filetype,BufEnter,BufNew,BufWinEnter,BufWrite
                \ * silent! lcd %:p:h
augroup end
" ---------------------------------------------------------------------------#
"  Sourcing external files
"  Since we have dependencies we do this last
"  --------------------------------------------------------------------------#
" let init_fpath = expand('%:p:h') 
let cfg_init_fpath = '/home/saeranv/.config/nvim'
let _lua_init_fpath = cfg_init_fpath . '/init/init.lua'
let _lsp_fpath = cfg_init_fpath . '/init/lsp.lua'
" 'lua require' will cache, so for dynamic updates 
" manually exe w/ luafile lua require('init')
execute 'luafile ' . _lua_init_fpath
execute 'luafile ' . _lsp_fpath
