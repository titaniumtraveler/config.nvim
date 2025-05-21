---@type LazyPluginSpec
local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
}

---@type Gitsigns.Config
---@diagnostic disable-next-line: missing-fields
M.opts = {
  preview_config = {
    border = "rounded",
  },
}

M.keys = {
  {
    "<leader>sa",
    function()
      require "gitsigns.actions".stage_hunk()
    end,
  },
  {
    "<leader>sa",
    function()
      require "gitsigns.actions".stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end,
    mode = "v",
  },
  {
    "<leader>sd",
    function()
      require "gitsigns.actions".reset_hunk()
    end,
  },
  {
    "<leader>sd",
    function()
      require "gitsigns.actions".reset({ vim.fn.line("."), vim.fn.line("v") })
    end,
    mode = "v",
  },
  {
    "<leader>ss",
    function()
      require "gitsigns.actions".preview_hunk()
    end,
  },
  {
    "<leader>sS",
    function()
      require "gitsigns.actions".preview_hunk_inline()
    end,
  },
  {
    "<leader>sk",
    function()
      require "gitsigns.actions".nav_hunk("prev")
    end,
  },
  {
    "<leader>sj",
    function()
      require "gitsigns.actions".nav_hunk("next")
    end,
  },
  {
    "<leader>sb",
    function()
      require "gitsigns.actions".toggle_current_line_blame()
    end,
  },
  {
    "<leader>sB",
    function()
      require "gitsigns.actions".blame()
    end,
  },
}

return M
