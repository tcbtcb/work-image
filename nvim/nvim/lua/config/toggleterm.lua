loacl M = {}

function M.setup()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if not status_ok then 
    return 
  end

toggleterm.setup({
  size = 120,
  open_mapping = [[c-\]],
  direction = "vertical",
})

return M
