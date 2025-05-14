local awful = require("awful")
local naughty = require("naughty")

local M = {}

--- @param callback fun(id: integer|nil)
function M.status(callback)
  awful.spawn.easy_async("fcitx5-remote", function(mode)
    callback(tonumber(mode))
  end)
end

function M.toggle()
  awful.spawn("fcitx5-remote -t", false)
end

-- TODO: Make custom indicator widget
---@param mode string
local function notify(mode)
  naughty.notification({
    app_name = "Mozc",
    title = "Input Method",
    message = "Input method changed to " .. mode,
  })
end

function M.hiragana()
  M.status(function(mode)
    if mode == 2 then
      awful.spawn("xvkbd -xsendevent -text '\\[Hiragana]'", false)
      notify("Hiragana")
    end
  end)
end

function M.katakana()
  M.status(function(mode)
    if mode == 2 then
      awful.spawn("xvkbd -xsendevent -text '\\[Katakana]'", false)
      notify("Katakana")
    end
  end)
end

return M
