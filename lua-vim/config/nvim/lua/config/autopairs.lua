local M = {}

function M.setup()
  local npairs = require "nvim-autopairs"
  npairs.setup {
    map_cr = true,
  }
end

return M
