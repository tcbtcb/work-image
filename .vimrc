set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'raimondi/delimitmate'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-jdaddy'
Plugin 'scrooloose/syntastic'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Install L9 and avoid a Naming conflict if you've already installed a
" " different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax on
set clipboard=unnamed

let mapleader =','
set path+=**
""""""""""""""""""""""
"" General settings ""
""""""""""""""""""""""

set nobackup
set nowritebackup
set noswapfile

set hidden
set autoread
set history=1000
set backspace=indent,eol,start

set wildmenu
set wildmode=longest,full
set wildignore+=tmp,.bundle,.sass-cache,.git,.svn,.hg,doc,coverage,vendor,node_modules,deps

set scrolloff=3
set splitright
set splitbelow

set t_vb=
set noerrorbells
set novisualbell
set t_Co=256
set ttyfast
set lazyredraw
set timeoutlen=500

"""""""""""""""""""""""""
"" Colors + formatting ""
"""""""""""""""""""""""""
"
" set cursorline
set nowrap
set synmaxcol=200 " Do not highlight long lines
set softtabstop=2
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set autoindent
set smartindent
set nojoinspaces
set number
set numberwidth=4
set encoding=utf-8
set list
set listchars=tab:\·\ ,trail:·,eol:¬

" remote traling whitespace in python 

autocmd BufWritePre *.py %s/\s\+$//e 


""""""""""""""
"" Searches ""
""""""""""""""

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

"""""""""""""""""""""
"" Window movement ""
"""""""""""""""""""""

" set window moves to avoid the C-w key combo

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l


""""""""""""""""""""""
"" Language settings""
""""""""""""""""""""""

" python settings
"
au BufNewFile,BufRead *.py
    \ set tabstop=4        |
    \ set softtabstop=4    |
    \ set shiftwidth=4     |
    \ set textwidth=79     |
    \ set expandtab        |
    \ set autoindent       |
    \ set fileformat=unix  

"""""""""""""""""""""
"" Plugin settings ""
"""""""""""""""""""""
" Ultisnips config

let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" YouCompleteMe

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" fugitive mappings
nmap <leader>gs :Gstatus<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>ge :Gedit<CR>
nmap <leader>gbl :Gblame<CR>
nmap <leader>gv :Gvsplit<CR>
nmap <leader>gr :Gread<CR>
nmap <leader>gw :Gwrite<CR>
nmap <leader>gbr :Gbrowse<CR>
nmap <leader>gp :Gpush<CR>
nmap <leader>gl :Glog<CR>

" syntastic sesttings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers=[ 'jshint' ]
let g:syntastic_python_checkers=[ 'pylint' ]
let g:syntastic_json_checkers=[ 'jsonlint' ]
let g:syntastic_html_checkers=[ 'tidy' ]
nmap <leader>pr :SyntasticCheck proselint
nmap <leader>sn :SyntasticToggleMode<CR>

" Gundo

nnoremap <leader>u :GundoToggle<CR>

" ultisnips
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
