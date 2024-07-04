---@type LazyPluginSpec
local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
}

M.opts = {
  preview_config = {
    border = "rounded",
  },
}

return M
