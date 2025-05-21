local function set_keymap(_, bufnr)
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

  vim.b.custom_formatting = true

  set("n", "<Leader>f", function()
    if vim.b.custom_formatting then
      require "conform".format { lsp_fallback = true }
    end
  end, opts)

  set("n", "<Leader>ls", vim.lsp.buf.document_symbol, opts)
  set("n", "<Leader>lS", vim.lsp.buf.workspace_symbol, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp config on_attach", {}),
  callback = function(args)
    set_keymap(nil, args.buf)
  end,
})

---@type vim.lsp.Config
return {
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities = require "cmp_nvim_lsp".default_capabilities(capabilities)

    return capabilities
  end)(),
  on_attach = {
    set_keymap,
  },
}
