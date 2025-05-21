---@type vim.lsp.Config
return {
  cmd = {
    "cargo",
    "run",
    "--package",
    "kdl-lsp-2",
  },

  single_file_support = true,

  filetypes = { "kdl" },

  root_markers = {
    ".git",
    ".git/",
  },

  settings = {
    ["kdl_lsp_crate"] = {
      schema = "<path>",
    },
  },
}
