return {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false

      vim.lsp.config.ts_ls.on_attach(client, bufnr)
    end,
}
