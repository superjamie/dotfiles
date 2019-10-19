" pathogen - https://github.com/tpope/vim-pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

""" general
set autoindent      " indent the same amount as the previous line on CR
set hidden          " allow moving to another buffer without saving
set hlsearch        " highlight search results
set linebreak       " don't wrap text in the middle of a word
set listchars=tab:»\ ,eol:¬ " set list characters to be similar to TextMate
set modeline        " enable modelines
set noshowmode      " don't show -- INSERT --
set number          " show line numbers
set scrolloff=3     " number of lines to keep visible when scrolling
set title           " show title in console
set smarttab        " tab on blankline inserts a shiftwidth, backspace deletes a shifwidth
set splitbelow      " start splits below the current window
set splitright      " start splits to the right of the current window
set wildmenu        " command autocompletion menu
syntax enable       " enable syntax highlighting

set expandtab       " expand tabs to spaces
set tabstop=4       " consider 4 spaces to be a tab
set shiftwidth=4    " when < or > shifting, move to 4-space boundaries
set softtabstop=4   " when halfway thru spacing and hit tab, end at 4 space gaps

""" statusline
set laststatus=2    " always show the statusline
"OLD set statusline=%<\ %f\ %h%m%r%y\ (buf\ %n)%=(%p%%)\ col:%c\ ln:%l/%L\

" filetypes
autocmd BufNewFile,BufReadPost *.ino set filetype=c    " arduino
autocmd FileType c    setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
autocmd FileType cpp  setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
autocmd FileType diff setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8
autocmd FileType xml  setlocal   expandtab tabstop=2 shiftwidth=2 softtabstop=2

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

" brad's graphical copypaste - requires xclip
com! -range Xc :silent :<line1>,<line2>w !xclip -selection clipboard -i
ca xc Xc
com! -range Xp :silent :r !xclip -selection clipboard -o
ca xp Xp

" E492 Not an editor command
ca Q q
ca W w

" vim-buftabline suggests
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" remove highlights
nnoremap <leader>h :nohl<CR>:match none<CR>:call clearmatches()<CR> :<Esc>
" toggle list characters
nnoremap <leader>l :set list!<CR>:set list?<CR>
" run make
nnoremap <leader>m :make<CR>
" toggle line numbers
nnoremap <leader>n :set number!<CR>:set number?<CR>
" toggle paste mode
" set pastetoggle=<leader>p
nnoremap <Leader>p :set paste!<CR>
" toggle relative line numbers
nnoremap <leader>r :set relativenumber!<CR>:set relativenumber?<CR>
" reload config
nnoremap <leader>v :source ~/.vimrc<CR>

" markdown bold current word
nnoremap <leader>b :s/\(<c-r>=expand("<cword>")<cr>\)/**&**/<CR>:nohl<CR>
" markdown italic current word
nnoremap <leader>i :s/\(<c-r>=expand("<cword>")<cr>\)/*&*/<CR>:nohl<CR>

""" plugins
" bundle / lightline vim-colors-solarized vim-fugitive vim-markdown vim-surround

" gtags-cscope.vim
if has("cscope")
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    let GtagsCscope_Auto_Load = 1
    let GtagsCscope_Auto_Map = 1
    let GtagsCscope_Quiet = 1
endif

" markdown - https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1

" solarized color scheme - http://ethanschoonover.com/solarized
let g:solarized_contrast = "high" " default value is normal
let g:solarized_termtrans = 1     " transparent terminal
set background=dark
colorscheme solarized

" lightline
let g:lightline = { 'colorscheme': 'solarized', }
augroup reload_vimrc
    autocmd!
    autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END
