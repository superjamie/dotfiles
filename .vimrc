""" vimrc v2023-06-32 - https://superjamie.github.io/
" tested on Vim 9 only
syntax on
filetype plugin indent on
""" theme - https://draculatheme.com/vim
let g:dracula_bold = 0
let g:dracula_italic = 0
let g:dracula_underline = 0
let g:dracula_full_special_attrs_support = 1
let g:dracula_colorterm = 0
colorscheme dracula

""" general
set autoindent       " indent the same amount as the previous line on CR
set cindent          " C-style indenting
set noerrorbells     " BEEP (for DOS vim)
set nofoldenable     " disable folding
set formatoptions-=c " stop comments wrapping at textwidth (:help fo-table)
set hidden           " allow moving to another buffer without saving
set hlsearch         " highlight search results
set incsearch        " incremental search as you type
set linebreak        " don't wrap text in the middle of a word
set listchars=tab:>\ ,eol:$,trail:-,extends:>,precedes:<,nbsp:+ "
set modeline         " https://vim.fandom.com/wiki/Modeline_magic
set mouse=           " disable mouse
set number           " show line numbers
set relativenumber   " enable hybrid line numbers
set scrolloff=1      " number of lines to keep visible when scrolling
set title            " show title in console
set ttimeoutlen=1    " timeout to consider Esc as Meta key
set smarttab         " tab on blank line inserts a shiftwidth, backspace deletes
set splitbelow       " start splits below the current window
set splitright       " start splits to the right of the current window
set wildmenu         " command autocompletion menu (try :color <Tab> to see)

set expandtab        " expand tabs to spaces
set tabstop=4        " consider 4 spaces to be a tab
set shiftwidth=4     " when < or > shifting, move to 4-space boundaries
" when halfway thru spacing and you hit tab, end at (shiftwidth) gaps
if has('softtabstop') | set softtabstop=-1 | endif

" gvim
if has("gui_running")
  set guifont=PxPlus\ IBM\ VGA\ 8x16\ 12
endif

" put ~backups .swp .un~ in /tmp/%full%file%path instead of current directory
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

""" clipboard (vim-gtk3)
" use system clipboard for all yank/delete/change/put operations
if has("unnamedplus")
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

""" filetypes and autogroups
augroup configs
    autocmd!
    autocmd BufNewFile,BufReadPost *.ino set filetype=c  " arduino
    autocmd BufWritePre *.py :%s/\s\+$//e  " strip trailing whitespace on save
    autocmd FileType c,cpp setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8 complete+=,i
    autocmd FileType c,cpp source ~/.vim/syntax/sdl2.vim
    autocmd FileType diff  setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
    autocmd FileType make  setlocal noexpandtab
    autocmd FileType xml   setlocal   expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" simpler version of https://github.com/farmergreg/vim-lastplace
augroup jump_to_this_files_last_cursor_position
    autocmd!
    " exclude invalid, event handler, and commit messages
    autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \ |   exe "normal! g`\""
            \ | endif
augroup END

" use nested when sourcing vimrc - https://github.com/itchyny/lightline.vim/issues/102
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

""" key remaps
" buffers
noremap <silent> <leader>b :buffers<cr>
" close current buffer without closing split, switches to b# (previous buffer)
nnoremap <silent> <leader>d :b#<bar>bd#<CR>
" from vim-unimpaired
noremap [b :bprev<CR>
noremap ]b :bnext<CR>
noremap [B :bfirst<CR>
noremap ]B :blast<CR>

" exit :terminal buffer insert mode with Esc
tnoremap <Esc> <C-\><C-n>

" quickfix list
noremap ]q :cnext<cr>
noremap [q :cprev<cr>
" E492 Not an editor command
command Q q
command W w

""" functions
" remove trailing whitespace, return to last position
function! Tw()
    %s/\s*$//
    ''
endfunction

" toggle right margin column visual aid
function! ColorColumn()
    if exists('+colorcolumn')
        if &colorcolumn != 81
            set colorcolumn=81,101,121
        else
            set colorcolumn=0
        endif
    else
        " fallback - highlight lines over 80 characters in red
        nnoremap <leader>8 :call matchadd('Search', '\%80v.\+', 100)<CR>:<Esc>
    endif
endfunction

""" leader maps
" look for lines over 80 characters
nnoremap <silent> <leader>8 :call ColorColumn()<CR>
" highlight cursor position
nnoremap <silent> <leader>c :set cursorline!<CR>:set cursorcolumn!<CR>
" remove search highlights by clearing last search pattern
"nnoremap <silent> <leader>h :nohl<CR>:match none<CR>:call clearmatches()<CR>
nnoremap <silent> <leader>h :let @/ = ""<cr>
" toggle list characters
nnoremap <leader>l :set list!<CR>:set list?<CR>
" toggle line numbers
nnoremap <silent> <leader>n :set relativenumber!<CR>:set number!<CR>
" toggle relative line numbers
nnoremap <silent> <leader><leader> :set relativenumber!<CR>
" toggle paste mode
nnoremap <leader>p :set paste!<CR>:set paste?<CR>
" spell check
nnoremap <leader>s :setlocal spell! spelllang=en_au<CR>:set spell?<CR>
" reload vim config, repply filetype to the current file so 'augroup Filetype' runs again
nnoremap <silent> <leader>v :source ~/.vimrc<CR>:exe ':set filetype='.&filetype<CR>
" remove trailing whitespace, return cursor to current position
nnoremap <silent> <leader>w :call Tw()<cr>:match none<CR>:call clearmatches()<CR>
" re-indent whole file (mm creates mark m, gg=G indents, `m goes to mark m)
map <Leader>= mmgg=G`m

""" plugins - complete list of plugins i use
"" absolute essentials
" https://github.com/dracula/vim
" https://github.com/justinmk/vim-sneak
"" nice to have
" https://github.com/superjamie/zeroline.vim - my basic statusline
" https://github.com/ervandew/supertab - turns tab into completion key
" https://github.com/ap/vim-buftabline - view buffers in the tabline
" https://github.com/tpope/vim-fugitive - git integration as :Git or :G
" https://github.com/jeffkreeftmeijer/vim-numbertoggle - smart relative/absolute line numbers
" https://github.com/bronson/vim-trailing-whitespace - highlights trailing whitespace in red
" https://github.com/Valloric/ListToggle - toggle quickfix and location lists with a key
"" optional
" https://github.com/takac/vim-hardtime - stop repeating keys like jjjjjj

""" language support
" if you use different stuff to me, you might want to just use https://github.com/sheerun/vim-polyglot
"" C
" https://github.com/bfrg/vim-cpp-modern
" https://github.com/gregkh/kernel-coding-style
" https://cvs.savannah.gnu.org/viewvc/*checkout*/global/global/gtags-cscope.vim
" https://github.com/keltar/sdl2_vim_syntax
" https://github.com/brobeson/Tools/blob/master/vim/vim/ftplugin/cpp_cppcheck.vim
"" markdown
" https://github.com/preservim/vim-markdown

""" plugin settings
"" https://github.com/justinmk/vim-sneak
let g:sneak#label = 1

"" https://github.com/ap/vim-buftabline
let g:buftabline_numbers = 1  " 0 = off. 1 = buffer number. 2 = ordinal number
hi BufTabLineActive  cterm=none ctermfg=253 ctermbg=235
hi BufTabLineCurrent cterm=none ctermfg=253 ctermbg=238
hi BufTabLineFill    cterm=none ctermfg=242 ctermbg=235
hi BufTabLineHidden  cterm=none ctermfg=242 ctermbg=235
hi StatusLineNC      cterm=none ctermfg=242 ctermbg=235

"" https://github.com/Valloric/ListToggle
let g:lt_location_list_toggle_map = '<leader>o'
let g:lt_quickfix_list_toggle_map = '<leader>q'

"" gtags-cscope
if has("cscope")
    set cscopequickfix=s-,g-,c-,e-,f-,a-
    " regenerate gtags
    function! Retag()
        !gtags
        :cs reset
    endfunction
    nnoremap <leader>r :call Retag()<CR>
    nmap <leader>G :cs add GTAGS<CR>
    let GtagsCscope_Auto_Load = 1
    let GtagsCscope_Auto_Map = 1
    let GtagsCscope_Quiet = 1
endif

"" markdown - https://github.com/preservim/vim-markdown
let g:vim_markdown_auto_insert_bullets = 1   " maybe set 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_italics_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

"" https://github.com/takac/vim-hardtime
let g:hardtime_maxcount = 3
let g:hardtime_default_on = 1

"" vim-lsp
"" https://github.com/MaskRay/ccls/wiki/vim-lsp
if executable('ccls')
    augroup lsp_ccls
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'ccls',
                    \ 'cmd': {server_info->['ccls']},
                    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
                    \ 'initialization_options': {'cache': {'directory': expand('~/.cache/ccls') }},
                    \ 'allowlist': ['c', 'cpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
    augroup end
endif

"" https://jonasdevlieghere.com/vim-lsp-clangd/
"if executable('clangd')
"    augroup lsp_clangd
"        autocmd!
"        autocmd User lsp_setup call lsp#register_server({
"                    \ 'name': 'clangd',
"                    \ 'cmd': {server_info->['clangd']},
"                    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
"                    \ 'allowlist': ['c', 'cpp'],
"                    \ 'initialization_options': {'cache': {'directory': expand('~/.cache/clangd') }},
"                    \ 'allowlist': ['c', 'cpp'],
"                    \ })
"        autocmd FileType c setlocal omnifunc=lsp#complete
"        autocmd FileType cpp setlocal omnifunc=lsp#complete
"    augroup end
"endif

" https://github.com/prabirshrestha/vim-lsp
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=no
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>R <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    "" changed
    nnoremap <buffer> <expr><c-k> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-j> lsp#scroll(-4)
    "" added
    nmap <buffer> <f2> <plug>(lsp-rename)
    let g:lsp_diagnostics_highlights_delay = 50
    let g:lsp_diagnostics_signs_enabled = 0
    let g:lsp_document_code_action_signs_enabled = 0
    let g:lsp_document_highlight_delay = 50  "highlight symbol under cursor
    let g:lsp_format_sync_timeout = 1000
    let g:lsp_inlay_hints_enabled = 0
    let g:lsp_fold_enabled = 0
    let g:lsp_semantic_enabled = 0
    if exists("loaded_supertab") | call SuperTabSetDefaultCompletionType("<c-x><c-o>") | endif
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"""testing
"" debug what syntax highlight is applied under the cursor
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap <f12> :call SynGroup()<CR>
" https://github.com/luochen1990/rainbow#troubleshooting
nnoremap <f8> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
nnoremap <f9> :echo ("hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">")<cr>
nnoremap <f10> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
nnoremap <f11> :exec 'syn list '.synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>

"" https://github.com/luochen1990/rainbow
let g:rainbow_active = 1
let g:rainbow_conf = { 'ctermfgs': [33, 166, 75, 141] }
" defaults
" 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
" 'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],

" cursor shape - https://stackoverflow.com/questions/42377945/vim-adding-cursorshape-support-over-tmux-ssh
set t_SI=[6\ q
set t_SR=[4\ q
set t_EI=[2\ q
" undercurl - https://github.com/vim/vim/issues/6174#issuecomment-636869793
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" https://honk.any-key.press/u/continue/h/2qS1KGX2z11bCCXFRn
" grep for word under cursor, open results in quickfix list
nnoremap <leader>g :execute
          \ "grep! -R -I --exclude-dir=.git
                       \ --exclude=*.orig
                       \ --exclude=.*.swp
                       \ --exclude=*.rej
                       \ --exclude=*~ "
                       \ . shellescape("\\<" . expand("<cword>") . "\\>")
                       \ . " ."<cr>:copen<cr><cr>
" termguicolors - https://stackoverflow.com/questions/62702766/termguicolors-in-vim-makes-everything-black-and-white
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

""" legacy
" graphical copypaste (requires xclip)
"com! -range Xc :silent :<line1>,<line2>w !xclip -selection clipboard -i
"ca xc Xc
"com! -range Xp :silent :r !xclip -selection clipboard -o
"ca xp Xp

" quickfix list
"nnoremap <leader>q :cclose<CR>
"nnoremap <leader>Q :copen<CR>

""" theme - https://github.com/altercation/vim-colors-solarized
"set background=dark
"let g:solarized_italic = 0
"let g:solarized_bold = 0
"colorscheme solarized
"highlight Sneak cterm=none ctermfg=White ctermbg=DarkMagenta
"hi BufTabLineActive  cterm=none ctermfg=Black  ctermbg=Yellow
"hi BufTabLineCurrent cterm=none ctermfg=Black  ctermbg=Cyan
"hi BufTabLineFill    cterm=none ctermfg=Yellow ctermbg=Black
"hi BufTabLineHidden  cterm=none ctermfg=Yellow ctermbg=Black

""" disable command history (q:) and Ex mode (Q)
"nnoremap q: <Nop>
"nnoremap Q <Nop>

" open terminal in split
"nnoremap <leader>t :sp +term<cr>
"nnoremap <leader>T :vsp +term<cr>
