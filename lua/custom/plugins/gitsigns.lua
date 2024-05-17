---@type LazyPluginSpec
local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
}

M.opts = {
  _signs_staged_enable = true,
  preview_config = {
    border = "rounded",
  },
}

return M
