set nocompatible              " be iMproved, required

source /root/.config/nvim/plug-config/plugins.vim
source /root/.config/nvim/general.vim
source /root/.config/nvim/plug-config/coc/coc.vim
source /root/.config/nvim/plug-config/coc/coc-extensions.vim

""""""""""""""""""""""
"  PLUG-IN SETTINGS  "
""""""""""""""""""""""

" COC.VIM settings
" Give more space for displaying messages.
set cmdheight=2

" update quicker
set updatetime=300

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

" definition shortcuts 
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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
nmap <leader>fs :Gstatus<CR>
nmap <leader>fc :Gcommit<CR>
nmap <leader>fd :Gdiff<CR>
nmap <leader>fe :Gedit<CR>
nmap <leader>fbl :Gblame<CR>
nmap <leader>fv :Gvsplit<CR>
nmap <leader>fr :Gread<CR>
nmap <leader>fw :Gwrite<CR>
nmap <leader>fbr :Gbrowse<CR>
nmap <leader>fp :Gpush<CR>
nmap <leader>mm :<c-u>:Gwrite<bar>Gcommit -m WIP<bar>Gpush mini main<cr>

" TERRAFORM
au BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
let g:terraform_fmt_on_save=1

" GITGUTTER
let g:gitgutter_git_executable = '/usr/bin/git'

" FLOATERM
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_new    = '<F2>'

let g:floaterm_shell = 'zsh'

nmap <F3> :FloatermNew lf<CR>
nmap <F4> :FloatermNew ranger<CR>
nmap <F5> :FloatermNew lazygit<CR>

" EASY ALIGN
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
