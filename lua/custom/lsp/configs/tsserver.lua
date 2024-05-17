local default = require "custom.lsp.configs"

return {
  opts = {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      default.opts.on_attach(client, bufnr)
    end,
  },
}
