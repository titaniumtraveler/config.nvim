---@class custom.lib.reload_on_notify
local M = {}

---@class custom.lib.reload_on_notify.WatchedEntries: { [integer]: uv.uv_fs_event_t }
local WatchedEntries = {}
WatchedEntries.__index = setmetatable({}, WatchedEntries)
function WatchedEntries:stop_all()
  vim
    .iter(self)
    :filter(function(k, _)
      return type(k) == "number"
    end)
    ---@param k integer
    ---@param v uv.uv_fs_event_t
    :each(function(k, v)
      v:stop()
      self[k] = nil
    end)
end

M.watched_entries = WatchedEntries

---@param buf integer?
---@return { [integer]: [integer;2]  }
function M.buf_get_visible_cursors(buf)
  if not buf or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end

  return vim
    .iter(vim.api.nvim_tabpage_list_wins(0))
    :map(function(win)
      local window_buf = vim.api.nvim_win_get_buf(win)

      if window_buf == buf then
        return win
      end
    end)
    :map(function(win)
      return win, vim.api.nvim_win_get_cursor(win)
    end)
    :fold({}, function(acc, win, cur)
      acc[win] = cur

      return acc
    end)
end

---@param win_to_cur_map { [integer]: [integer,integer] }
function M.restore_cursors(win_to_cur_map)
  vim.iter(pairs(win_to_cur_map)):each(
    ---@param win integer
    ---@param cursor [integer;2]
    function(win, cursor)
      vim.api.nvim_win_set_cursor(win, cursor)
    end
  )
end

---@param buf integer?
---@return uv.uv_fs_event_t?
function M.reload_buf(buf)
  if not buf or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end

  if M.watched_entries[buf] then
    vim.notify("buffer " .. buf .. " already registered", vim.log.levels.WARN)
    return
  end

  local fs_event = vim.uv.new_fs_event()
  if fs_event == nil then
    return nil
  end

  ---@type string
  local file = vim.api.nvim_buf_call(buf, function()
    return vim.fn.expand("%:p")
  end)

  M.watched_entries[buf] = fs_event

  vim.api.nvim_set_option_value("readonly", true, { scope = "local", buf = buf })
  local last_time = vim.uv.now() - 1000

  fs_event:start(file, {}, function()
    vim.schedule(function()
      local size = vim.uv.fs_stat(file).size
      if size == 0 then
        return
      end

      -- Debounce events to only trigger every second
      -- except the first one
      if vim.uv.now() - last_time < 1000 then
        return
      end
      last_time = vim.uv.now()

      local cursors = M.buf_get_visible_cursors(buf)

      if type(next(cursors)) == "nil" then
        return
      end

      vim.api.nvim_buf_call(buf, function()
        vim.api.nvim_cmd({ cmd = "edit", bang = true }, {})
      end)

      M.restore_cursors(cursors)
    end)
  end)

  return fs_event
end

M.version = os.time()

function M:reload_module()
  vim.print { "prev version", M.version }
  local mod = M
  if self then
    mod = self
  end

  local buffers = vim
    .iter(mod.watched_entries)
    :inspect()
    :map(function(k)
      if type(k) == "number" then
        return k
      end
    end)
    :totable()

  mod.watched_entries:stop_all()
  package.loaded["custom.lib.reload_on_inotify"] = false

  local reload = require("custom.lib.reload_on_inotify")
  vim.iter(buffers):each(mod.reload_buf)
  mod = reload
end

return M
