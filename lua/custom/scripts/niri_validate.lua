local M = {}

---@class Iter
local Iter = require "custom.lib.iterators"

M.opts = {
  augroup = vim.api.nvim_create_augroup("niri-validate", {}),
  namespace = vim.api.nvim_create_namespace("niri-validate"),
}

---@param file string
---@return string[]
function M.run_cmd(file)
  return vim.fn.systemlist {
    "niri",
    "validate",
    "--json",
    "--config",
    file,
  }
end

---@alias schema schema.string | schema.function | schema.table
---@alias schema.string type
---@alias schema.function fun(val: any): boolean, string?
---@alias schema.table schema.table.config | schema.table.any
---@alias schema.table.any table<string, schema>
---@class schema.table.config
---custom function to validate the table
---@field type fun(name: string, val: any, schema: schema.table)?

---@param name string
---@param value any
---@param schema schema
---@diagnostic disable-next-line: unused-function
local function validate(name, value, schema)
  if type(schema) == "string" or type(schema) == "function" then
    ---@cast schema schema.string | schema.function
    vim.validate(name, value, schema)
  elseif type(schema) == "table" then
    ---@diagnostic disable-next-line: cast-type-mismatch
    ---@cast schema schema.table
    if schema.type then
      schema.type(name, value, schema)
    else
      vim.validate(name, value, "table")
      for k, v in pairs(value) do
        if schema[k] then
          validate(name .. "." .. k, v, schema[k])
        else
          -- vim.notify(
          --   name .. "[" .. vim.inspect(k) .. "] = " .. vim.inspect(value) .. " was ignored",
          --   vim.log.levels.DEBUG
          -- )
        end
      end
    end
  end
end

---@param name string
---@param value any
---@param schema { item: schema }
local function validate_array(name, value, schema)
  for k, v in pairs(value) do
    if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
      error("invalid key in array" .. vim.inspect(k, v), vim.log.levels.ERROR)
    end
    validate(name .. "[" .. vim.inspect(k) .. "]", value, schema.item)
  end
end

---@param name string
---@param value string
---@param schema { one_of: table<string,true> }
local function validate_one_of(name, value, schema)
  if not schema.one_of[value] then
    error(name .. ": `" .. value .. "` not part of enum `" .. vim.inspect(schema.one_of) .. "`")
  end
end

---@param name string
---@param value string
---@param schema schema.table.config
local function validate_optional(name, value, schema)
  if value ~= nil then
    ---@diagnostic disable-next-line: param-type-mismatch
    validate(name, value, schema)
  end
end

---@class niri-validate.report
---@field message string
---@field severity niri-validate.report.severity
---@field filename string
---@field labels niri-validate.report.label
---@field related niri-validate.report

---@class niri-validate.report.label
---@field label string
---@field span niri-validate.report.label.span

---@class niri-validate.report.label.span
---@field offset number
---@field length number
---@field start niri-validate.report.label.line_span?
---@field end   niri-validate.report.label.line_span?

---@class niri-validate.report.label.line_span
---@field line number
---@field col  number

---@alias niri-validate.report.severity
---| "advice"
---| "warning"
---| "error"

---@type schema.table
local report_schema = {
  message = "string",
  severity = {
    type = validate_one_of,
    one_of = {
      advice = true,
      warning = true,
      error = true,
    },
  },
  filename = "string",
  ---@type schema.table.config
  labels = {
    type = validate_array,
    ---@type schema.table.any
    item = {
      label = "string",
      ---@type schema.table.any
      span = {
        offset = "number",
        length = "number",
        start = {
          type = validate_optional,
          line = "number",
          col = "number",
        },
        ["end"] = {
          type = validate_optional,
          line = "number",
          col = "number",
        },
      },
    },
  },
  related = "table",
}

---@type table<niri-validate.report.severity, vim.diagnostic.Severity>
local severity_map = {
  advice = vim.log.levels.INFO,
  warning = vim.log.levels.WARN,
  error = vim.log.levels.ERROR,
}

---@param offset integer
---@return integer
---@return integer
local function byte_offset_to_pos(offset)
  local line = vim.fn.byte2line(offset)
  local line_start = vim.fn.line2byte(line)
  local col = offset - line_start + 1

  return line - 1, col
end

---@param json_lines string[]
---@param bufnr integer
---@param filename string
---@return vim.Diagnostic[]
function M.parse_diagnostics(json_lines, bufnr, filename)
  return vim
    .iter(json_lines)
    :map(function(line)
      local ok, report = pcall(vim.json.decode, line)
      if ok then
        ---@diagnostic disable-next-line: param-type-mismatch
        validate("report", report, report_schema)
        return "report", report
      end
    end)
    :recursive_flat_map(function(tag, ...)
      if "report" == tag then
        ---@type niri-validate.report
        local report = ...
        local iter = Iter.empty()

        if report.filename == filename then
          iter = iter:chain(vim.iter(report.labels):map(function(label)
            return "label", report.message, report.severity, label
          end))
        end

        iter = iter:chain(vim.iter(report.related):map(function(related_report)
          return "report", related_report
        end))

        return true, iter
      elseif "label" == tag then
        ---@type string, niri-validate.report.severity, niri-validate.report.label
        local report_message, severity, label = ...

        local start_span = label.span.start
        local end_span = label.span["end"]

        local lnum, col = start_span.line, start_span.col
        local end_lnum, end_col = end_span.line, end_span.col

        -- vim.api.nvim_buf_call(bufnr, function()
        --   local offset = label.span.offset
        --   local length = label.span.length
        --
        --   lnum, col = byte_offset_to_pos(offset)
        --   end_lnum, end_col = byte_offset_to_pos(offset + length)
        -- end)

        ---@type vim.Diagnostic
        local diagnostic = {
          namespace = M.opts.namespace,
          bufnr = bufnr,
          source = "niri-validate",
          severity = severity_map[severity],

          message = report_message .. "\n" .. label.label .. "\n",
          lnum = lnum,
          col = col,
          end_lnum = end_lnum,
          end_col = end_col,
        }
        return false, diagnostic
      end
      return false, Iter.empty()
    end)
    :totable()
end

---@param args { buf: integer, file: string } | vim.api.keyset.create_autocmd.callback_args
function M.update_diagnostics(args)
  local json_lines = M.run_cmd(args.file)
  local diagnostics = M.parse_diagnostics(json_lines, args.buf, args.file)
  vim.diagnostic.set(M.opts.namespace, args.buf, diagnostics)
end

---@param buf? integer
function M.setup_for_buf(buf)
  buf = buf or 0

  M.update_diagnostics {
    buf = buf,

    file = vim.api.nvim_buf_call(buf, function()
      return vim.fn.expand("%f")
    end),
  }

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M.opts.augroup,
    buffer = buf or 0,
    callback = M.update_diagnostics,
  })
end

return M
