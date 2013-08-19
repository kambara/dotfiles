call pathogen#infect()

syntax on

filetype on
filetype indent on
filetype plugin on

set incsearch
set ts=4 sw=4 expandtab
set showmatch
set autoindent
set smartindent
set wildmenu
set hlsearch
set ignorecase

au FileType ruby :set nowrap tabstop=2 tw=0 sw=2 expandtab

au BufNewFile,BufRead *.kahua setf scheme
au BufNewFile,BufRead *.sc setf scheme
