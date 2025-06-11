return {
	"ibhagwan/fzf-lua",
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	keys = {
		{
			"<leader>ff",
			function()
				require("fzf-lua").files()
			end,
			{ desc = "Find files in currnet working dir" },
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			{ desc = "Find via grep in currnet working dir" },
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").builtin()
			end,
			{ desc = "Find via built in views" },
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			{ desc = "Find in neovim help" },
		},
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles()
			end,
			{ desc = "Find in most recently used files" },
		},
	},
}
