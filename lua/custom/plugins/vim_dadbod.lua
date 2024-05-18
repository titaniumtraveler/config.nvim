---@type LazyPluginSpec
local M = {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    {
      "kristijanhusak/vim-dadbod-completion",
      ft = { "sql", "mysql", "plsql" },
      dependencies = {
        "hrsh7th/nvim-cmp",
        "tpope/vim-dadbod",
      },
    },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1

    require "cmp".setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
  end,
}

return M
