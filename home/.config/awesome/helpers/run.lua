local awful = require("awful")

local M = {}

local script = [[
  pgrep -U $USER -x $(basename "%s" | cut -d ' ' -f 1 | cut -c 1-15) || \
    (nohup %s >/dev/null 2>&1 &)
]]

local toggle_script = script:gsub("pgrep", "pkill")

-- Run if not already running
function M.once(cmd)
  awful.spawn.with_shell(script:format(cmd, cmd))
end

-- Kill process if already running, otherwise run the process
function M.toggle(cmd)
  awful.spawn.with_shell(toggle_script:format(cmd, cmd))
end

return M
