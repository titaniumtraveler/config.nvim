---@type LazyPluginSpec
local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "crispgm/telescope-heading.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "Telescope" },
}

function M.config()
  local telescope = require "telescope"
  local actions = require "telescope.actions"

  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<CR>"] = actions.select_default,
        },
      },
      prompt_prefix = "$ ",
      file_ignore_patterns = { "%.git/", "%.cargo/.*/", "%.rustup/", "%.cache", "%.fzf" },
      initial_mode = "insert",
    },
    extensions = {
      heading = {
        treesitter = true,
      },
    },
  }

  telescope.load_extension "fzf"
  telescope.load_extension "file_browser"
  telescope.load_extension "ui-select"
  telescope.load_extension "heading"
end

M.keys = {
  {
    "<Leader>ff",
    function()
      require "telescope.builtin".find_files { hidden = true }
    end,
  },
  {
    "<Leader>fg",
    function()
      require "telescope.builtin".live_grep()
    end,
  },
  {
    "<Leader>fG",
    function()
      require "telescope.builtin".current_buffer_fuzzy_find()
    end,
  },
  {
    "<Leader>fb",
    function()
      require "telescope.builtin".buffers()
    end,
  },
  {
    "<Leader>fd",
    function()
      require "telescope".extensions.file_browser.file_browser { hidden = true }
    end,
  },
  {
    "<Leader>fh",
    function()
      require "telescope.builtin".help_tags()
    end,
  },
  {
    "<Leader>fm",
    function()
      require "telescope.builtin".man_pages { sections = { "ALL" } }
    end,
  },

  {
    "<Leader>fs",
    function()
      require "telescope.builtin".spell_suggest()
    end,
  },

  {
    "<Leader>fk",
    function()
      require "telescope.builtin".keymaps()
    end,
  },
  {
    "<Leader>fc",
    function()
      require "telescope.builtin".builtin()
    end,
  },
  {
    "<Leader>fl",
    function()
      require "telescope.builtin".lsp_document_symbols()
    end,
  },
  {
    "<Leader>fL",
    function()
      require "telescope.builtin".lsp_workspace_symbols()
    end,
  },
  {
    "<Leader>fr",
    function()
      require "telescope.builtin".lsp_references()
    end,
  },
}

return M
