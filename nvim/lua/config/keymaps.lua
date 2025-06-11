vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "open parent dir in oil" })

--vim.keymap.set("n", "<leader>gl", function()
--	vim.diagnostic.open_float()
-- end, { desc = "Open diagnostics in float win" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "[c]ode [f]ormat called manually" })

-- toggle term
vim.keymap.set("n", "tt", ":ToggleTerm<cr>", { desc = "[t]oggle [t]erm to open" })
vim.keymap.set("n", "tf", ":ToggleTerm direction=float<CR>", { desc = "[t]oggle [f]loat" })
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "<Escape> to leave edit mode" })
-- vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]])
-- vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]])
-- vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]])
-- vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]])
