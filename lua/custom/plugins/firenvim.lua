---@type LazyPluginSpec
local M = {
  "glacambre/firenvim",
  cond = function()
    return vim.g.started_by_firenvim
  end,
  lazy = false,
}

function M.config()
  local group = vim.api.nvim_create_augroup("firevim", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = "sqlhero.it.bbwi_*",
    callback = function()
      vim.opt.filetype = "sql"
    end,
  })
end

return M
