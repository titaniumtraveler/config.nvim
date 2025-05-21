---@class Iter
local Iter = getmetatable(vim.iter(function() end))

---@return Iter
function Iter:inspect()
  return self:map(function(...)
    print(vim.inspect { ... })
    return ...
  end)
end

--- Repeat t n times
---@param n integer
---@param t any
---@return Iter
function Iter.times(n, t)
  local it = {}

  function it:next()
    if 0 < n then
      n = n - 1
      return t
    end
    return nil
  end

  return setmetatable(it, Iter)
end

---@param f fun(...):boolean,...
---@param ... any Arguments to apply to f
---@return true? cont True if the iterator pipeline should continue, false otherwise
---@return ... Return values of f
local function apply(f, ...)
  if select(1, ...) ~= nil then
    return true, f(...)
  end
  return ...
end

---@param f fun(...):boolean,Iter|any, ...
---@return Iter
function Iter:recursive_flat_map(f)
  local stack = { self }

  ---@param cont true?
  ---@param rec boolean
  ---@param ... ...
  ---@return ...
  local function fn(cont, rec, ...)
    if cont then
      if rec then
        table.insert(stack, ...)
        return fn(apply(f, stack[#stack]:next()))
      else
        return ...
      end
    elseif 1 < #stack then
      table.remove(stack)
      return fn(apply(f, stack[#stack]:next()))
    else
      return ...
    end
  end

  local it = {
    next = function()
      return fn(apply(f, stack[#stack]:next()))
    end,
  }

  return setmetatable(it, Iter)
end

function Iter.empty()
  local it = {
    next = function()
      return nil
    end,
  }
  return setmetatable(it, Iter)
end

function Iter:chain(...)
  ---@type Iter
  local iters = vim.iter({ ... })
  local cur = self

  local function fn(...)
    if select(1, ...) ~= nil then
      return ...
    end

    cur = iters:next()
    if cur == nil then
      return nil
    end

    return fn(cur:next())
  end

  local it = {
    next = function()
      return fn(cur:next())
    end,
  }
  return setmetatable(it, Iter)
end

-- print(Iter
--   .times(1, 5)
--   :chain(vim.iter { 1, 2, 3 })
--   :inspect()
--   :recursive_flat_map(function(item)
--     if 0 < item then
--       return true, vim.iter { item - 1, item - 1 }
--     else
--       return false, 0
--     end
--   end)
--   -- :inspect()
--   :fold(0, function(a)
--     return a + 1
--   end))

-- vim
--   .iter({
--     {
--       name = "name",
--       count = 3,
--     },
--   })
--   :inspect()
--   :flat_map(function(item)
--     -- vim.print { ctx = "iter", item = item }
--     if not item._count then
--       item._count = item.count
--       return true, vim.iter { vim.deepcopy(item), vim.deepcopy(item) }
--     else
--       if 0 < item._count then
--         item._count = item._count - 1
--         return true, vim.iter { vim.deepcopy(item), vim.deepcopy(item) }
--       end
--     end
--     return false, item
--   end)
--   :inspect()
--   :take(50)
--   :each(function(...) end)

return Iter
