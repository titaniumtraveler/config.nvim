---@type LazyPluginSpec
local M = {
  "dev/autoscheme.nvim",
  dev = true,
  lazy = false,
  priority = 1000,
}

function M.config()
  require "autoscheme".setup { "base16.toml" }

  vim.cmd.colorscheme "base16"
end

return M
