local awful = require("awful")

local _M = {}

local get_process_name = function(cmd)
  local process_name = cmd
  local firstspace = process_name:find(" ")

  -- Remove args
  if firstspace then
    process_name = process_name:sub(0, firstspace - 1)
  end

  -- Remove executable path
  if process_name:find("/") then
    process_name = process_name:match("([%w-]+)$")
  end

  -- Cut process name to max 15 chars
  if process_name:len() > 15 then
    process_name = process_name:sub(1, 15)
  end

  return process_name
end

-- Run if not already running
_M.once = function(cmd)
  local process_name = get_process_name(cmd)

  awful.spawn.easy_async(string.format("pgrep -U %s -ix %s", os.getenv("USER"), process_name), function(out)
    if out ~= "" then
      return
    end

    awful.spawn(cmd, false)
  end)
end

return _M
