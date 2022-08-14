local status, packer = pcall(require, "packer")
if (not status) then 
  print("Packer is not installe")
  return
end

vim.cmd [[ packadd packer.nvim ]]

packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'cocopon/iceberg.vim'
	use 'windwp/nvim-autopairs'
	use 'nvim-lualine/lualine.nvim'
        use 'nvim-lua/plenary.nvim'  
        use 'onsails/lspkind-nvim' 
        use 'hrsh7th/cmp-buffer' 
        use 'hrsh7th/cmp-nvim-lsp' 
        use 'hrsh7th/cmp-cmdline' 
        use 'hrsh7th/nvim-cmp' 
	use {
    		'nvim-treesitter/nvim-treesitter',
    		run = ':TSUpdate'
  	}
        use 'kyazdani42/nvim-web-devicons' 
	use 'jose-elias-alvarez/null-ls.nvim'
	use 'glepnir/lspsaga.nvim'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
        use 'nvim-telescope/telescope.nvim'
        use 'nvim-telescope/telescope-file-browser.nvim'
	use 'lewis6991/gitsigns.nvim'
end)
