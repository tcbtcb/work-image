local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
keymap.set('n', 'te', ':tabedit')
-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- toggle term
keymap.set('n', 'tt', ':ToggleTerm<cr>')
keymap.set('n', 'tf', ':ToggleTerm direction=float<CR>')
keymap.set('t', '<esc>', '<C-\\><C-n>')
keymap.set('t', '<C-h>', [[<C-\><C-n><C-W>h]])
keymap.set('t', '<C-j>', [[<C-\><C-n><C-W>j]])
keymap.set('t', '<C-k>', [[<C-\><C-n><C-W>k]])
keymap.set('t', '<C-l>', [[<C-\><C-n><C-W>l]])

-- colorscheme
keymap.set('n', 'cst', ':colorscheme tokyonight<CR>')
keymap.set('n', 'csi', ':colorscheme iceberg<CR>')
