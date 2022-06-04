local M = {}

function M.setup()
  local whichkey = require "which-key"

  local conf = {
    window = {
      border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
    },
  }

  local opts = {
    mode = "n", -- Normal mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }

  local mappings = {
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },

   f = {
      name = "Find",
      f = { "<cmd>lua require('utils.finder').find_files()<cr>", "Files" },
      d = { "<cmd>lua require('utils.finder').find_dotfiles()<cr>", "Dotfiles" },
      b = { "<cmd>Telescope buffers<cr>", "Buffers" },
      o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
      g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
      c = { "<cmd>Telescope commands<cr>", "Commands" },
      r = { "<cmd>Telescope file_browser<cr>", "Browser" },
      w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
      e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    },

    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close Buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete All Buffers" },
    },

    k = {
      name = "Kettelman",
      T = { "<cmd>Telekasten goto_today<cr>", "Today's note" },
      d = {"<cmd>Telekasten find_daily_notes<CR>", "Find daily notes" },
      f = {"<cmd>Telekasten find_notes<CR>", "Find notes" },
      g = {"<cmd>Telekasten search_notes<CR>", "Search notes" },
      z = {"<cmd>Telekasten follow_link<CR>", "Follow link" },
      W = {"<cmd>Telekasten goto_thisweek<CR>", "This week's note"},
      w = {"<cmd>Telekasten find_weekly_notes<CR>", "Find weekly notes" },
      n = {"<cmd>Telekasten new_note<CR>", "New note" },
      N = {"<cmd>Telekasten new_templated_note<CR>", "New note w/ template" },
      y = {"<cmd>Telekasten yank_notelink<CR>", "Yank note link" },
      c = {"<cmd>Telekasten show_calendar<CR>", "Show calendar" },
      i = {"<cmd>Telekasten paste_img_and_link<CR>", "Paste image and link" },
      t = {"<cmd>Telekasten toggle_todo<CR>", "Show Todo" },
      b = {"<cmd>Telekasten show_backlinks<CR>", "Show backlinks" },
      F = {"<cmd>Telekasten find_friends<CR>", "Find friends" },
      I = {"<cmd>Telekasten insert_img_link({ i=true })<CR>", "Insert image link" },
      p = {"<cmd>Telekasten preview_img<CR>", "Preview image" },
      m = {"<cmd>Telekasten browse_media<CR>", "Browse media" },
      a = {"<cmd>Telekasten show_tags<CR>", "Show tags" },
      r = {"<cmd>Telekasten rename_note<CR>", "Rename note" },
      C = {"<cmd>CalendarT<CR>", "Calendar T"}
    },

    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      p = { "<cmd>PackerProfile<cr>", "Profile" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    g = {
      name = "Git",
      s = { "<cmd>Neogit<CR>", "Status" },
    },
  }

  whichkey.setup(conf)
  whichkey.register(mappings, opts)
end

return M
