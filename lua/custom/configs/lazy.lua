---@type LazyConfig
return {
  spec = {
    { import = "custom.plugins" },
  },
  defaults = { lazy = true },
  ui = { wrap = "true", border = "rounded" },
  change_detection = { enabled = true, notify = false },
  debug = false,
  log = {},
  dev = {
    path = "~/projects/lua",
    patterns = { "dev/" },
  },
}
