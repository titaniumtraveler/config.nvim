---@type LazyPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPost",
  dependencies = {
    -- "nvim-treesitter/playground",
    "nvim-tree/nvim-web-devicons",
  },
}

function M.config()
  require "nvim-treesitter.configs".setup {
    modules = {},
    ensure_installed = {},
    ignore_install = {},

    sync_install = false,
    auto_install = true,

    highlight = { enable = true },
    matchup = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },

    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  }
end

return M
