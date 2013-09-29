""" vim-pathogen
""" https://github.com/tpope/vim-pathogen
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

""" Ruby
au FileType ruby :set nowrap tabstop=2 tw=0 sw=2 expandtab

""" QFixHowm
set runtimepath+=~/.vim/qfixapp
let QFixHowm_Key = 'g'
let howm_dir             = '~/Dropbox/Private/howm-vim'
let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
let howm_fileencoding    = 'utf-8'
let QFixHowm_FileType    = 'org'
let QFixHowm_Title = '*'

