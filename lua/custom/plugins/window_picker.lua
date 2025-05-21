---@type LazyPluginSpec
return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  enabled = false,
  config = function()
    require("window-picker").setup({
      hint = "floating-big-letter",
    })
    vim.keymap.set("n", "<leader>mm", function()
      print(require "window-picker".pick_window())
    end)
  end,
}
