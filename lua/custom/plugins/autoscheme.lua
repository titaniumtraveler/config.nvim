---@type LazyPluginSpec
local M = {
  "titaniumtraveler/autoscheme.nvim",
  dev = false,
  lazy = false,
  priority = 1000,
}

function M.config()
  require "autoscheme".setup { "base16.toml" }

  vim.cmd.colorscheme "base16"
end

return M
