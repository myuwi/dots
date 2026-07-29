local awful = require("awful")
local gtimer = require("gears.timer")
local signal = require("tide.signal")

local function get_icon(volume, muted)
  if muted or volume == 0 then
    return "volume-x"
  end

  if volume >= 50 then
    return "volume-2"
  elseif volume >= 20 then
    return "volume-1"
  else
    return "volume"
  end
end

local state = signal({
  volume = 0,
  muted = false,
  icon = get_icon(0, false),
})

local command = "wpctl get-volume @DEFAULT_SINK@"

local function refresh(callback)
  awful.spawn.easy_async(command, function(stdout, _, _, exit_code)
    local volume_str = stdout:match("([%d.]+)")
    if exit_code == 0 and volume_str then
      local volume = math.floor(tonumber(volume_str) * 100)
      local muted = stdout:match("MUTED") ~= nil

      state:set({
        volume = volume,
        muted = muted,
        icon = get_icon(volume, muted),
      })

      if callback then
        callback()
      end
    end
  end)
end

local attempts_left = 10
local startup_timer
startup_timer = gtimer({
  timeout = 1,
  autostart = true,
  call_now = true,
  callback = function()
    if attempts_left <= 0 then
      startup_timer:stop()
      return
    end

    attempts_left = attempts_left - 1
    refresh(function()
      startup_timer:stop()
    end)
  end,
})

return {
  state = state,
  refresh = refresh,
  timer = startup_timer,
}
