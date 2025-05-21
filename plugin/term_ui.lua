vim.api.nvim_create_user_command("TermUI", function(args)
  ---@type vim.api.keyset.cmd
  local cmd = {
    cmd = "term",
    args = args.fargs,
  }

  vim.api.nvim_cmd(cmd --[[@as vim.api.keyset.cmd]], { output = true })
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd.startinsert()

  vim.keymap.set("t", "<C-w>", function()
    local fn = vim.fn
    local key = fn.nr2char(fn.getchar() --[[@as integer]])
    vim.cmd.wincmd(key)
  end, { buffer = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      vim.cmd.startinsert()
    end,
    buffer = buf,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
      vim.cmd.stopinsert()
    end,
    buffer = buf,
  })

  vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
    buffer = buf,
  })
end, {
  nargs = "*",
  ---@param _ _
  ---@param cmdline string
  ---@param pos any
  complete = function(_, cmdline, pos)
    cmdline = "term" .. cmdline:sub(("TermUI"):len() + 1, pos)
    local completions = vim.fn.getcompletion(cmdline, "cmdline")
    return completions
  end,
})
