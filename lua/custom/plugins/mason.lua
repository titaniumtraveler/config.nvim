---@type LazyPluginSpec
return {
  "williamboman/mason.nvim",
  event = { "BufReadPre" },
  cmd = { "Mason" },
  ---@type MasonSettings
  opts = {
    ui = {
      border = "rounded",
    },
  },
}
