---@module "lazy"
---@type LazyPluginSpec
local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neoconf.nvim",
  },
}

function M.config()
  require "mason-lspconfig".setup {
    enable = true,
  }
  vim.lsp.config("*", require "custom.lsp.config")
  -- vim.lsp.enable( "kdl_lsp")
  vim.lsp.enable("kdl_lsp_crate")

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
      source = true,
      header = "",
      prefix = "",
      suffix = "",
    },
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom_lsp", { clear = false }),
    pattern = "*",
    callback = function(_)
      if vim.b.custom_formatting then
        require "conform".format { lsp_fallback = true }
      end
    end,
  })
end

M.keys = {
  { "<Leader>ll", vim.cmd.Mason },
  { "<Leader>li", vim.cmd.LspInfo },
  { "<Leader>lr", vim.cmd.LspRestart },
  { "<Leader>lt", vim.cmd.LspStop },
}

return M
