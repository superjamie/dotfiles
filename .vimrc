""" vimrc v2023-01-25
" should work in NeoVim 0.8+ and Vim (recent-ish v8 or last v7 maybe?)
" https://superjamie.github.io/
syntax on
filetype plugin indent on

""" theme
" https://github.com/altercation/vim-colors-solarized
set background=dark
let g:solarized_italic = 0
let g:solarized_bold = 0
colorscheme solarized

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
set smarttab         " tab on blank line inserts a shiftwidth, backspc deletes
set splitbelow       " start splits below the current window
set splitright       " start splits to the right of the current window
set wildmenu         " command autocompletion menu (try :color <Tab> to see)

set expandtab        " expand tabs to spaces
set tabstop=4        " consider 4 spaces to be a tab
set shiftwidth=4     " when < or > shifting, move to 4-space boundaries
if has('softtabstop')
    set softtabstop=-1   " when halfway thru spacing and you hit tab, end at
    " 4-space gaps (-1 means use value of shiftwidth)
endif

""" neovim
" use system clipboard for all yank/delete/change/put operations
if has("unnamedplus")
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

""" statusline
set laststatus=2    " always show the statusline
set showmode        " show mode line ---INSERT---
" initialise to blank
set statusline=
" space, buffer number surrounded by [square braces]
set statusline+=\ [%n]
" space, filename (tail)
set statusline+=\ %t
" space, flags: modified, readonly, help, preview
set statusline+=\ %m%r%h%w
" right align
set statusline+=%=
" file format (line endings)
set statusline+=%{&ff}
" space, pipe, space, file encoding
set statusline+=\ \:\ %{''.(&fenc!=''?&fenc:&enc).''}
" space, pipe, space, filetype
set statusline+=\ \:\ %{&ft}
" space, pipe, space, min-3-width percent through file in lines
set statusline+=\ \:\ %2p%%
" space, pipe, space, min-4-width line number
set statusline+=\ \:\ %3l
" colon, min-2-character left-aligned virtual column number, space
set statusline+=:%-2v\ "

" put ~backups .swp .un~ in /tmp/%full%file%path instead of current directory
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

""" filetypes
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

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \ |   exe "normal! g`\""
            \ | endif

" https://github.com/itchyny/lightline.vim/issues/102
" You should always be using the nested flag for autocmd when sourcing your vimrc file
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" disable mouse
"autocmd BufEnter * set mouse=

""" remaps
" fix ctrl+arrow keys under tmux
map! <ESC>[1;5D <C-Left>
map! <ESC>[1;5C <C-Right>
map! <ESC>[1;5A <C-Up>
" buffer nav
noremap <C-Left> :bprev<CR>
noremap <C-Right> :bnext<CR>
noremap <C-h> :bprev<CR>
noremap <C-l> :bnext<CR>
" exit terminal buffer insert mode with double-Esc
tnoremap <Esc><Esc> <C-\><C-n>

" E492 Not an editor command
command Q q
command W w

" disable command history (q:) and Ex mode (Q)
map q: <Nop>
nnoremap Q <Nop>

""" functions
" remove trailing whitespace, return to last position
function! Tw()
    %s/\s*$//
    ''
endfunction

" toggle right margin column visual aid
function! ColorColumn()
    if exists('+colorcolumn')
        if &colorcolumn != 80
            set colorcolumn=80,100,120
        else
            set colorcolumn=0
        endif
    else
        " highlight lines over 80 characters in red
        nnoremap <leader>8 :call matchadd('Search', '\%80v.\+', 100)<CR>:<Esc>
    endif
endfunction

""" leader maps
" look for lines over 80 characters
nnoremap <leader>8 :call ColorColumn()<CR>
" highlight cursor position
nnoremap <leader>c :set cursorline!<CR>:set cursorcolumn!<CR>:<Esc>
" close current buffer without closing split, switches to b# (previous buffer)
nnoremap <leader>d :b#<bar>bd#<CR>
" remove highlights
nnoremap <leader>h :nohl<CR>:match none<CR>:call clearmatches()<CR>:<Esc>
" toggle list characters
nnoremap <leader>l :set list!<CR>:set list?<CR>
" toggle line numbers
nnoremap <leader>n :set relativenumber!<CR>:set number!<CR>:<Esc>
" toggle relative line numbers
nnoremap <leader><leader> :set relativenumber!<CR>:<Esc>
" toggle paste mode
nnoremap <Leader>p :set paste!<CR>:set paste?<CR>
" spell check
nnoremap <leader>s :setlocal spell! spelllang=en_au<CR>:set spell?<CR>
" remove trailing whitespace, return cursor to current position
nnoremap <leader>t :call Tw()<cr>:match none<CR>:call clearmatches()<CR>:<Esc>
" reload vim config
nnoremap <leader>v :source ~/.vimrc<CR>
" re-indent whole file (mm creates mark m, gg=G indents, `m goes to mark m)
map <Leader>= mmgg=G`m

""" plugins - complete list of plugins i use
"" absolute essentials
" https://github.com/altercation/vim-colors-solarized
" https://github.com/justinmk/vim-sneak
"" nice to have
" https://github.com/ervandew/supertab - turns tab into Ctrl+n completion key
" https://github.com/ap/vim-buftabline - view buffers in the tabline
" https://github.com/tpope/vim-fugitive - git integration, mostly :Git blame
" https://github.com/jeffkreeftmeijer/vim-numbertoggle - smart relative/absolute line numbers
" https://github.com/bronson/vim-trailing-whitespace - highlights trailing whitespace in red
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
" https://github.com/justinmk/vim-sneak
let g:sneak#label = 1

" https://github.com/ap/vim-buftabline
let g:buftabline_numbers = 1  " 0 = off. 1 = buffer number. 2 = ordinal number
" better look with solarized
if &background ==# "dark"
    hi BufTabLineActive  cterm=none ctermfg=Black  ctermbg=Yellow
    hi BufTabLineCurrent cterm=none ctermfg=Black  ctermbg=Cyan
    hi BufTabLineFill    cterm=none ctermfg=Yellow ctermbg=Black
    hi BufTabLineHidden  cterm=none ctermfg=Yellow ctermbg=Black
else
    hi BufTabLineActive  cterm=none ctermfg=White  ctermbg=Cyan
    hi BufTabLineCurrent cterm=none ctermfg=White  ctermbg=Green
    hi BufTabLineHidden  cterm=none ctermfg=Yellow ctermbg=none
    hi BufTabLineFill    cterm=none ctermfg=Yellow ctermbg=none
endif

" gtags-cscope
if has("cscope")
    " regenerate gtags
    function! Retag()
        !gtags
        :cs reset
    endfunction
    nnoremap <leader>r :call Retag()<CR>
    let GtagsCscope_Auto_Load = 1
    let GtagsCscope_Auto_Map = 1
    let GtagsCscope_Quiet = 1
    nmap <leader>G :cs add GTAGS<CR>
    " vertical split mappings
    nmap <C-s>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-s>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-s>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-s>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-s>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-s>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-s>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-s>a :vert scs find a <C-R>=expand("<cword>")<CR><CR>
endif

" markdown - https://github.com/preservim/vim-markdown
let g:vim_markdown_auto_insert_bullets = 1   " maybe set 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_italics_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

" https://github.com/takac/vim-hardtime
let g:hardtime_maxcount = 3
let g:hardtime_default_on = 1

""" testing
" https://stackoverflow.com/a/53930943/1422582
" Toggle signcolumn. Works on vim>=8.1 or NeoVim
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        let b:signcolumn_on=0
    else
        set signcolumn=yes
        let b:signcolumn_on=1
    endif
endfunction

""" legacy
" unmap arrow keys
noremap! <Up> <NOP>
noremap! <Down> <NOP>
noremap! <Left> <NOP>
noremap! <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
" graphical copypaste (requires xclip)
com! -range Xc :silent :<line1>,<line2>w !xclip -selection clipboard -i
ca xc Xc
com! -range Xp :silent :r !xclip -selection clipboard -o
ca xp Xp
