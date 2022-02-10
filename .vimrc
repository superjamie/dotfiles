" pathogen - https://github.com/tpope/vim-pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" https://github.com/ervandew/supertab
" https://github.com/superjamie/vim-bufferlist
" https://github.com/ap/vim-buftabline
" https://github.com/altercation/vim-colors-solarized
" https://github.com/tpope/vim-fugitive
" https://github.com/vivien/vim-linux-coding-style
" https://github.com/preservim/vim-markdown
" https://github.com/bronson/vim-trailing-whitespace

""" general
set autoindent      " indent the same amount as the previous line on CR
set hidden          " allow moving to another buffer without saving
set hlsearch        " highlight search results
set incsearch       " incremental search as you type
set linebreak       " don't wrap text in the middle of a word
set listchars=tab:>\ ,eol:$,trail:-,extends:>,precedes:<,nbsp:+ " based on vim-sensible
set modeline        " enable modelines
set number          " show line numbers
set scrolloff=1     " number of lines to keep visible when scrolling
set title           " show title in console
set smartindent     " intelligent C indenting
set smarttab        " tab on blankline inserts a shiftwidth, backspace deletes a shifwidth
set splitbelow      " start splits below the current window
set splitright      " start splits to the right of the current window
set wildmenu        " command autocompletion menu
syntax enable       " enable syntax highlighting

set expandtab       " expand tabs to spaces
set tabstop=4       " consider 4 spaces to be a tab
set shiftwidth=4    " when < or > shifting, move to 4-space boundaries
set softtabstop=-1  " when halfway thru spacing and hit tab, end at 4 space gaps (use value of shiftwidth)

""" theme
" https://github.com/altercation/vim-colors-solarized
set background=dark
colorscheme solarized

""" statusline
set laststatus=2    " always show the statusline
" i've gone too far with this, anyway...
function! StatusLineModeChange()
    set noshowmode
    let m = mode()
    let str = ''
    if (m =~# '\v(n|no)')
        let str = '  NORMAL '
        exe 'hi! StatusLineMode cterm=none ctermbg=DarkBlue ctermfg=White'
    elseif (m ==# 'i')
        let str = '  INSERT '
        exe 'hi! StatusLineMode cterm=none ctermbg=DarkGreen ctermfg=White'
    elseif (m =~# 'v')
        let str  = '  V-CHAR '
        exe 'hi! StatusLineMode cterm=none ctermbg=DarkMagenta ctermfg=White'
    elseif (m =~# 'V')
        let str = '  V-LINE '
        exe 'hi! StatusLineMode cterm=none ctermbg=DarkMagenta ctermfg=White'
    elseif (m ==# "\<C-V>")
        let str = '  V-BLOCK '
        exe 'hi! StatusLineMode cterm=none ctermbg=DarkMagenta ctermfg=White'
    elseif (m ==# 'R')
        let str = '  REPLACE '
        exe 'hi! StatusLineMode cterm=none ctermbg=DarkRed ctermfg=White'
    else
        set showmode
        let str = '  UNKNOWN '
        exe 'hi! StatusLineMode cterm=none ctermbg=Yellow ctermfg=White'
    endif
    if (&paste == 1)
        let str = str . '| PASTE '
    endif
    return str
endfunction

hi StatusLineMode cterm=none ctermbg=Blue ctermfg=White
hi StatusLineFile cterm=none ctermbg=Green ctermfg=White
hi StatusLineMid  cterm=none ctermbg=Black ctermfg=Cyan
hi StatusLinePerc cterm=none ctermbg=Green ctermfg=Cyan
hi StatusLinePos  cterm=none ctermbg=Cyan  ctermfg=8

set statusline=%#StatusLineMode#
set statusline+=%{StatusLineModeChange()}
set statusline+=%#StatusLineFile#
" space, buffer number surrounded by [square braces]
set statusline+=\ [%n]
" space, filename (tail)
set statusline+=\ %t
" space, flags: modified, readonly, help, preview
set statusline+=\ %m%r%h%w
" right align
set statusline+=%#StatusLineMid#
set statusline+=%=
" file format (line endings)
set statusline+=%{&ff}
" space, pipe, space, file encoding
set statusline+=\ \|\ %{''.(&fenc!=''?&fenc:&enc).''}
" space, pipe, space, filetype, space
set statusline+=\ \|\ %{&ft}\ "
" space, pipe, space, min-3-width percent through file in lines, space
set statusline+=%#StatusLinePerc#
set statusline+=\ %3p%%\ "
" space, pipe, space, min-4-width line number
set statusline+=%#StatusLinePos#
set statusline+=%4l
" colon, min-2-character left-aligned virtual column number, space
set statusline+=:%-2c\ "
" restore original statusline style for ModeMsg and other such things
set statusline+=%#StatusLine#

""" filetypes
augroup configs
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufNewFile,BufReadPost *.ino set filetype=c " arduino
    autocmd BufNewFile,BufRead *.fb,*.bi,*.bas setf freebasic
    autocmd BufWritePre *.py :%s/\s\+$//e  " strip trailing whitespace
    autocmd FileType c    setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
    autocmd FileType cpp  setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
    autocmd FileType diff setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
    autocmd FileType xml  setlocal   expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" put ~backups .swp .un~ in /tmp/%full%file%path
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

" stop comments wrapping at textwidth (:help fo-table)
autocmd FileType * setlocal formatoptions-=c

" disable mouse
autocmd BufEnter * set mouse=

""" key remaps

" unmap arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
" fix ctrl+arrow keys under tmux
map <ESC>[1;5D <C-Left>
map <ESC>[1;5C <C-Right>
map <ESC>[1;5A <C-Up>
map! <ESC>[1;5D <C-Left>
map! <ESC>[1;5C <C-Right>
map! <ESC>[1;5A <C-Up>
" buffer nav
noremap <C-Left> :bprev<CR>
noremap <C-Right> :bnext<CR>
noremap <C-h> :bprev<CR>
noremap <C-l> :bnext<CR>
" vim-buftabline suggests
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
" steve losch select-all
nnoremap va ggVG

" graphical copypaste (requires xclip)
com! -range Xc :silent :<line1>,<line2>w !xclip -selection clipboard -i
ca xc Xc
com! -range Xp :silent :r !xclip -selection clipboard -o
ca xp Xp

" E492 Not an editor command
ca Q q
command W w

map q: <Nop>     " disable command history
nnoremap Q <nop> " disable Ex mode

" remove trailing whitespace
function! Tw()
    %s/\s*$//
    ''
endfunction

" toggle column at 80 characters
function! ColorColumn()
    if exists('+colorcolumn')
        if &colorcolumn != 80
            set colorcolumn=80,100,120
        else
            set colorcolumn=0
        endif
    else
        " highlight lines over 80 characters in red
        nnoremap <leader>8 :call matchadd('Search', '\%80v.\+', 100)<CR> :<Esc>
    endif
endfunction

" https://github.com/vivien/vim-linux-coding-style
nnoremap <silent> <leader>a :LinuxCodingStyle<cr>
" look for lines over 80 characters
nnoremap <leader>8 :call ColorColumn()<CR>
" remove highlights
nnoremap <leader>h :nohl<CR>:match none<CR>:call clearmatches()<CR> :<Esc>
" toggle list characters
nnoremap <leader>l :set list!<CR>:set list?<CR>
" toggle line numbers
nnoremap <leader>n :set number!<CR>:set number?<CR>
" toggle paste mode
nnoremap <leader>p :set paste!<CR>:set paste?<CR>
" toggle relative line numbers
nnoremap <leader>r :set relativenumber!<CR>:set relativenumber?<CR>
" remove trailing whitespace
nnoremap <leader>t :call Tw()<cr>:match none<CR>:call clearmatches()<CR> :<Esc>
" reload config
nnoremap <leader>v :source ~/.vimrc<CR>
" remove trailing whitespace through whole document
nnoremap <leader>w :%s/\s\+$//<CR>:match<CR>:nohl<CR> :<Esc>
" re-indent whole file
map <Leader>= mmgg=G`m

""" plugins

" https://github.com/ap/vim-buftabline
let g:buftabline_numbers = 1  " 0 = off. 1 = buffer number. 2 = ordinal number
" better look with solarized dark
hi BufTabLineActive  cterm=none ctermfg=Black  ctermbg=Yellow
hi BufTabLineCurrent cterm=none ctermfg=Black  ctermbg=Cyan
hi BufTabLineFill    cterm=none ctermfg=Yellow ctermbg=Black
hi BufTabLineHidden  cterm=none ctermfg=Yellow ctermbg=Black

" cscope - https://vim.fandom.com/wiki/Cscope
if has("cscope")
    let GtagsCscope_Auto_Load = 1
    let GtagsCscope_Auto_Map = 1
    let GtagsCscope_Quiet = 1
endif

" markdown - https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

" https://github.com/itchyny/lightline.vim/issues/102
augroup reload_vimrc
    autocmd!
    autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

" https://github.com/roblillack/vim-bufferlist
nnoremap <leader><leader> :call BufferList()<CR> :<Esc><Esc>
let g:BufferListWidth = 125
hi BufferNormal   term=NONE    cterm=NONE ctermfg=White ctermbg=Black
hi BufferSelected term=reverse cterm=NONE ctermfg=White ctermbg=Green

