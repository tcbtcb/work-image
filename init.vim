set nocompatible              " be iMproved, required

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/goyo.vim'
Plug 'ervandew/supertab'
Plug 'hashivim/vim-terraform'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/vim-easy-align'
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'fatih/vim-go'
Plug 'voldikss/vim-floaterm'
Plug 'kiteco/vim-plugin'

call plug#end()

" temporarily trying the default leader key
" let mapleader =','

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
" Theme START
syntax on
colorscheme gruvbox
set background=dark
set cursorline
set hidden
set list
set listchars=tab:»·,trail:·

" let buffers be clickable
let g:lightline#bufferline#clickable=1
let g:lightline#bufferline#shorten_path=1
let g:lightline#bufferline#min_buffer_count=1

let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [ [], [], [ 'relativepath' ] ],
  \   'right': [ [], [], [ 'lineinfo', 'percent' ] ]
  \ },
  \ 'inactive': {
  \   'left': [ [], [], [ 'relativepath' ] ],
  \   'right': [ [], [], [ 'lineinfo', 'percent' ] ]
  \ },
  \ 'subseparator': {
  \   'left': '', 'right': ''
  \ },
  \ 'tabline': {
  \   'left': [ ['buffers'] ],
  \   'right': [ [] ]
  \ },
  \ 'tabline_separator': {
  \   'left': "", 'right': ""
  \ },
  \ 'tabline_subseparator': {
  \   'left': "", 'right': ""
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers'
  \ },
  \ 'component_raw': {
  \   'buffers': 1
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel'
  \ }
  \ }

" Theme END
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

" SUPERTAB

" SuperTab START
let g:SuperTabMappingForward = '<S-tab>'
let g:SuperTabMappingBackward = '<tab>'
" SuperTab END
 
" FUGITIVE

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

" NERDTREE 

map <leader>n :NERDTreeToggle<CR>

" TERRAFORM

au BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
let g:terraform_fmt_on_save=1

" VIM-GO settings

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" remap build/run/test
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" GITGUTTER

let g:gitgutter_git_executable = '/usr/bin/git'

" FLOATERM

let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_new    = '<F2>'

let g:floaterm_shell = 'bash'

nmap <F4> :FloatermNew ranger<CR>
nmap <F5> :FloatermNew lazygit<CR>

" KITE 
let g:kite_supported_languages = ['python', 'javascript', 'go']

