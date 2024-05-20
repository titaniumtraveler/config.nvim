vim.keymap.set({ "n", "i", "c", "v", "x", "s", "o", "l" }, "<C-j>", "<Esc>", { remap = true })
vim.keymap.set({ "n", "i", "c", "v", "x", "s", "o", "l" }, "<C-k>", "<Esc>", { remap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n>", { remap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n>", { remap = true })

vim.keymap.set({ "n", "i", "c" }, "<C-l>", "<CR>", { remap = true })

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")

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

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
