require('plugins')
require('keymappings')
require('settings')
require('colorscheme')

-- Plugins
require('nv-compe')
require('nv-colorizer')
require('nv-nvimtree')
require('nv-treesitter')
require('nv-galaxyline')
require('nv-bufferline')
require('nv-gitsigns')
require('nv-nvim-autopairs')
require('nv-kommentary')

-- LSP
require('lsp')
require('utils')
require('lsp.lua-ls')

-- languages
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.gopls.setup{}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
  capabilities = capabilities,
}
require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.tsserver.setup{}

-- pocker startup
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end
