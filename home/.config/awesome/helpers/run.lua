local awful = require("awful")

local M = {}

local script = [[
  pgrep -U $USER -x $(basename "%s" | cut -d ' ' -f 1 | cut -c 1-15) >/dev/null || \
    (nohup %s >/dev/null 2>&1 & disown && echo $!)
]]

local toggle_script = script:gsub("pgrep", "pkill")

-- Run if not already running
function M.once(cmd, cb)
  awful.spawn.easy_async_with_shell(script:format(cmd, cmd), function(stdout)
    if cb then
      cb(stdout:match("%d+"))
    end
  end)
end

-- Kill process if already running, otherwise run the process
function M.toggle(cmd, cb)
  awful.spawn.easy_async_with_shell(toggle_script:format(cmd, cmd), function(stdout)
    if cb then
      cb(stdout:match("%d+"))
    end
  end)
end

return M
