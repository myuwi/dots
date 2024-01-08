local awful = require("awful")
local naughty = require("naughty")

local _M = {}

--- @param callback fun(id: integer|nil)
_M.status = function(callback)
  awful.spawn.easy_async("fcitx5-remote", function(mode)
    callback(tonumber(mode))
  end)
end

_M.toggle = function()
  awful.spawn("fcitx5-remote -t", false)
end

-- TODO: Make custom indicator widget
---@param mode string
function notify(mode)
  naughty.notification({
    app_name = "Mozc",
    title = "Input Method",
    message = "Input method changed to " .. mode,
  })
end

_M.hiragana = function()
  _M.status(function(mode)
    if mode == 2 then
      awful.spawn("xvkbd -xsendevent -text '\\[Hiragana]'", false)
      notify("Hiragana")
    end
  end)
end

_M.katakana = function()
  _M.status(function(mode)
    if mode == 2 then
      awful.spawn("xvkbd -xsendevent -text '\\[Katakana]'", false)
      notify("Katakana")
    end
  end)
end

return _M
