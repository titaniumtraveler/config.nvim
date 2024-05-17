local set = vim.keymap.set

set({ "n", "i", "c", "v", "x", "s", "o", "l" }, "<C-j>", "<Esc>", { remap = true })
set({ "n", "i", "c", "v", "x", "s", "o", "l" }, "<C-k>", "<Esc>", { remap = true })
set("t", "<C-j>", "<C-\\><C-n>", { remap = true })
set("t", "<C-k>", "<C-\\><C-n>", { remap = true })

set({ "n", "i", "c" }, "<C-l>", "<CR>", { remap = true })

set("n", "<leader>w", "<cmd>w<cr>")

set({ "n", "v" }, "<C-h>", vim.cmd.nohlsearch)

-- jump to start and end of line using the home row keys
set({ "n", "v", "s", "o" }, "H", "^")
set({ "n", "v", "s", "o" }, "L", "$")

-- switch to alternative buffer
set("n", "<Leader><leader>", "<C-^>")

set("n", "<Leader>,", function()
  ---@diagnostic disable-next-line
  vim.opt.list = not vim.opt.list:get()
end)

set("n", "<Leader>e", vim.diagnostic.open_float)
