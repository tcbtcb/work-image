" Theme START
syntax on
colorscheme gruvbox
set background=dark
set cursorline
set hidden
set list
set listchars=tab:»·,trail:·
set number

"
" Or, you could use neovim's floating text feature.
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
" To use a custom highlight for the float window,
" change Pmenu to your highlight group
highlight link EchoDocFloat Pmenu

