---@type LazyPluginSpec
local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
}

function M.config()
  require "mason-lspconfig".setup_handlers {
    function(server)
      local default = require "custom.lsp.configs"

      local require_ok, config = pcall(require, "custom.lsp.configs." .. server)
      if require_ok and config ~= false then
        default = vim.tbl_deep_extend("force", default, config)
      end

      default.setup(server, default.opts)
    end,
  }

  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      suffix = "",
    },
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom_lsp", { clear = false }),
    pattern = "*",
    callback = vim.lsp.buf.format,
  })
end

return M
