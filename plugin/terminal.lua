vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    if not vim.api.nvim_get_option_value("buflisted", { buf = args.buf }) then
      return
    end

    local buf = args.buf
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
        if vim.v.event.status == 0 and vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end,
      buffer = buf,
    })
  end,
})
