return {
  opts = {
    before_init = require "neodev.lsp".before_init,
    settings = {
      Lua = {
        format = {
          enable = false,
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.stdpath "config" .. "/lua"] = true,
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}
