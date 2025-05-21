vim.keymap.set({ "n", "i", "c", "v", "x", "s", "o", "l" }, "<C-j>", "<Esc>", { remap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n>", { remap = true })

vim.keymap.set({ "n", "i", "c" }, "<C-l>", "<CR>", { remap = true })

vim.keymap.set("n", "<leader>w", vim.cmd.write)

vim.keymap.set("n", "<leader>t", function()
  vim.api.nvim_cmd({ cmd = "split", mods = { tab = -1 } }, {})
end)

vim.keymap.set({ "n", "v" }, "<C-h>", vim.cmd.nohlsearch)

-- jump to start and end of line using the home row keys
vim.keymap.set({ "n", "v", "s", "o" }, "H", "^")
vim.keymap.set({ "n", "v", "s", "o" }, "L", "$")

-- switch to alternative buffer
vim.keymap.set("n", "<Leader><leader>", "<C-^>")

vim.keymap.set("n", "<Leader>,", function()
  ---@diagnostic disable-next-line
  vim.opt.list = not vim.opt.list:get()
end)

vim.keymap.set("i", "<A-j>", "`")

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<leader>ds", vim.diagnostic.show)
vim.keymap.set("n", "<leader>dh", vim.diagnostic.hide)

---@class vim.fn.getqflist.list
---@field bufnr	any number of buffer that has the file name, use bufname() to get the name
---@field module any	module name
---@field lnum any	line number in the buffer (first line is 1)
---@field end_lnum any end of line number if the item is multiline
---@field col any	column number (first column is 1)
---@field end_col any	end of column number if the item has range
---@field vcol any	|true|: "col" is visual column |FALSE|: "col" is byte index
---@field nr any	error number
---@field pattern any	search pattern used to locate the error
---@field text any	description of the error
---@field type any	type of the error, 'E', '1', etc.
---@field valid any	|true|: recognized error message
---@field user_data any custom data associated with the item, can be any type.

---@class vim.fn.setqflist.list (strict)
---@field bufnr any	buffer number; must be the number of a valid buffer
---@field filename any	name of a file; only used when "bufnr" is not present or it is invalid.
---@field module any	name of a module; if given it will be used in quickfix error window instead of the filename.
---@field lnum any	line number in the file
---@field end_lnum any	end of lines, if the item spans multiple lines
---@field pattern any	search pattern used to locate the error
---@field col any		column number
---@field vcol any	when non-zero: "col" is visual column when any zero: "col" is byte index
---@field end_col any	end column, if the item spans multiple columns
---@field nr any		error number
---@field text any	description of the error
---@field type any	single-character error type, 'E', 'W', etc.
---@field valid any	recognized error message
---@field user_data any custom any data associated with the item, can be any type.

vim.keymap.set("n", "<leader>sr", function()
  ---@type vim.fn.getqflist.list
  local list = vim.fn.getqflist()

  local serialized = {}
  for _, value in pairs(list) do
    ---@type vim.fn.getqflist.list
    table.insert(serialized, {
      filename = vim.fn.bufname(value.bufnr),
      module = value.module,
      lnum = value.lnum,
      end_lnum = value.end_lnum,
      pattern = value.pattern,
      col = value.col,
      vcol = value.vcol,
      end_col = value.end_col,
      nr = value.nr,
      text = value.text,
      type = value.type,
      valid = value.valid,
      user_data = value.user_data,
    })
  end

  vim.fn.setreg('"', vim.json.encode(serialized))
end)
vim.keymap.set("n", "<leader>sw", function()
  local list = vim.json.decode(vim.fn.getreg('"'))

  vim.fn.setqflist(list, "r")
end)
