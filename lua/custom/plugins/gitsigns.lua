---@type LazyPluginSpec
local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
}

---@type Gitsigns.Config
---@diagnostic disable-next-line: missing-fields
M.opts = {
  preview_config = {
    border = "rounded",
  },
}

return M
