local M = {}

M.config = function()
  local status_ok, dapui = pcall(require, "dapui")
  if not status_ok then
    return
  end

  local opts = {
    layouts = {
      {
        -- You can change the order of elements in the sidebar
        elements = {
          -- Provide IDs as strings or tables with "id" and "size" keys
          { id = "watches",     size = 0.25 },
          { id = "scopes",      size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks",      size = 0.25 },
        },
        size = 40,
        position = "left", -- Can be "left" or "right"
      },
      {
        elements = {
          -- "repl",
          "console",
        },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      },
    },
  }

  dapui.setup(opts)
end

return M
