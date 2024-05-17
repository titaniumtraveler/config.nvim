---@type LazyPluginSpec
local M = {
  "dev/autoscheme.nvim",
  dev = true,
  lazy = false,
  priority = 1000,
}

function M.config()
  -- Note that this assumes that a file called `base16.toml` exists in `vim.fn.stdpath "config"`
  -- This file comes from <https://github.com/titaniumtraveler/base16-nvim.toml>
  -- and I usually just symlink it here. (Though I might change that in the future.)
  require "autoscheme".setup { "base16.toml" }

  vim.cmd.colorscheme "base16"
end

return M
