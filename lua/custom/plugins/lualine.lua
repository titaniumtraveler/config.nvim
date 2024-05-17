---@type LazyPluginSpec
local M = {
  "nvim-lualine/lualine.nvim",
  event = { "VimEnter", "InsertEnter", "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
}

function M.config()
  local lualine = require "lualine"

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    colored = true,
    always_visible = true,
  }

  local diff = {
    "diff",
    cond = function()
      return vim.fn.winwidth(0) > 80
    end,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    colored = true,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
  }

  local location = {
    "location",
    padding = 1,
  }

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  lualine.setup {
    options = {
      globalstatus = true,
      icons_enabled = true,
      -- This will be fixed in https://github.com/nvim-lualine/lualine.nvim/pull/1081
      -- and can then be replaced by just `"auto"`
      theme = require "custom.plugins.lualine.base16-theme",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename", "branch" },
      lualine_c = { diagnostics },
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  }
end

return M
