local M = {}

M.defaults = {
  buf_set_lsp_keymaps = function(_, bufnr)
    local set = vim.keymap.set
    local opts = {
      remap = false,
      silent = true,
      buffer = bufnr,
    }

    set("n", "<Leader>gd", vim.lsp.buf.definition, opts)
    set("n", "<Leader>gD", vim.lsp.buf.declaration, opts)
    set("n", "<Leader>gt", vim.lsp.buf.type_definition, opts)
    set("n", "<Leader>gi", vim.lsp.buf.implementation, opts)
    set("n", "<Leader>gr", vim.lsp.buf.references, opts)

    set("n", "K", vim.lsp.buf.hover, opts)
    set("i", "<C-y>", vim.lsp.buf.signature_help, opts)

    set("n", "<Leader>r", vim.lsp.buf.rename, opts)
    set("n", "<Leader>a", vim.lsp.buf.code_action, opts)
    set("n", "<Leader>f", function()
      require "conform".format { lsp_fallback = true }
    end, opts)

    set("n", "<Leader>ls", vim.lsp.buf.document_symbol, opts)
    set("n", "<Leader>lS", vim.lsp.buf.workspace_symbol, opts)
  end,
}

M.opts = {
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities = require "cmp_nvim_lsp".default_capabilities(capabilities)

    return capabilities
  end)(),
  on_attach = function(client, bufnr)
    M.defaults.buf_set_lsp_keymaps(client, bufnr)
  end,
}

function M.setup(name, opts)
  require "lspconfig"[name].setup(opts)
end

return M
