return {
  {
    "Pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        message = function()
          return ""  -- Keine Nachricht beim Speichern
        end,
      },
      trigger_events = { "InsertLeave", "TextChanged" },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- Nicht speichern für bestimmte Filetypes
        if fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buf, "&filetype"), {
            "oil",
            "neo-tree",
          }) then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 135,
    },
  },
}