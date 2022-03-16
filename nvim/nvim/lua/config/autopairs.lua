local M = {}

function M.setup()
  local npairs = require "nvim-autopairs"
  npairs.setup {
    map_bs = false, 
    map_cr = false
  }
end

vim.g.coq_settings = { keymap = { recommended = false } }

return M
