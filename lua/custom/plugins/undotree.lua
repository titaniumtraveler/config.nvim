---@type LazyPluginSpec
return {
  "mbbill/undotree",
  keys = { {
    "<leader>st",
    vim.cmd.UndotreeToggle,
  } },
}
