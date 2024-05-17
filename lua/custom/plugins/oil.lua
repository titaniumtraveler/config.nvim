---@type LazyPluginSpec
local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

M.opts = {
  default_file_explorer = true,
  view_options = {
    is_hidden_file = function(name, bufnr)
      if name == ".." then
        return false
      elseif name == ".git" then
        return true
      end

      local cmd = { "git", "check-ignore", vim.api.nvim_buf_get_name(bufnr):sub(("oil:///"):len()) .. name }

      local cmd_output = vim.fn.system(cmd)

      if vim.v.shell_error == 0 then
        return true
      elseif vim.v.shell_error == 1 then
        return false
      else
        error("failed executing command `" .. vim.inspect(cmd) .. '` with "' .. cmd_output .. '"')
      end
    end,
  },
  keymaps = {
    ["<C-l>"] = false,
    ["<C-t>"] = false,
  },
}

M.keys = {
  {
    "<Leader>oo",
    function()
      require "oil".open()
    end,
  },
  {
    "<Leader>ow",
    function()
      require "oil".open(vim.loop.cwd())
    end,
  },
}

return M
