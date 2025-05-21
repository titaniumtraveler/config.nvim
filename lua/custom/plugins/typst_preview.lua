---@type LazyPluginSpec
return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  opts = {
    port = 8000,
    dependencies_bin = {
      tinymist = "tinymist",
      websocat = "websocat",
    },
  },
}
