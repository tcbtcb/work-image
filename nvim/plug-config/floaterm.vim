let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_new    = '<F2>'

let g:floaterm_shell = 'bash'

nmap <F3> :FloatermNew --width=0.4 --wintype=vsplit --position=right --name=floaterm1<CR>
nmap <F5> :FloatermNew --width=0.3 --wintype=split --name=floaterm2<CR>

" Floaterm
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

tnoremap <C-W>n <C-\><C-n>
