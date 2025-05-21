---@type LazyPluginSpec
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "Neogit" },
  ---@type NeogitConfig
  opts = {
    mappings = {
      status = {
        ["<Leader>1"] = "Depth1",
        ["<Leader>2"] = "Depth2",
        ["<Leader>3"] = "Depth3",
        ["<Leader>4"] = "Depth4",
      },
    },
  },
  keys = {
    {
      "<Leader>bb",
      function()
        require "neogit".open {}
      end,
    },
  },
}
