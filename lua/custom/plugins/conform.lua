---@type LazyPluginSpec
return {
  "stevearc/conform.nvim",
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      tex = { "latexindent" },
      sql = { "sql_formatter" },
    },
  },
}
