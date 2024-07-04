---@type LazyPluginSpec
local M = {
  "ravibrock/spellwarn.nvim",
  event = "VeryLazy",
}

function M.config()
  require "spellwarn".setup()

  local ns = vim.api.nvim_get_namespaces()["Spellwarn"]
  vim.diagnostic.config({ virtual_text = false }, ns)
end

return M
