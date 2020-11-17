set nocompatible              " be iMproved, required

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'junegunn/goyo.vim'
Plug 'hashivim/vim-terraform'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/vim-easy-align'

call plug#end()

" COC.VIM settings

" status line
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Give more space for displaying messages.
set cmdheight=4

" update quicker
set updatetime=300

"
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" cargo cult
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

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

" TERRAFORM

au BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
let g:terraform_fmt_on_save=1

" GITGUTTER

let g:gitgutter_git_executable = '/usr/bin/git'

" FLOATERM

let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_new    = '<F2>'

let g:floaterm_shell = 'bash'

nmap <F4> :FloatermNew ranger<CR>
nmap <F5> :FloatermNew lazygit<CR>

" EASY ALIGN
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
