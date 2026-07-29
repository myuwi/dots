local awful = require("awful")
local gears = require("gears")
local signal = require("tide.signal")

local function empty()
  return {
    connected = false,
    kind = "none",
    label = "Network",
    icon = "ethernet-port",
  }
end

local function parse_device(line)
  local device, kind, state, connection = line:match("^([^:]*):([^:]*):([^:]*):(.*)$")
  if not device then
    return
  end

  return {
    device = device,
    kind = kind,
    state = state,
    connection = connection,
  }
end

local function normalize(device)
  if not device then
    return empty()
  end

  local label
  if device.kind == "wifi" then
    label = "Wi-Fi"
  elseif device.kind == "ethernet" then
    label = "Wired"
  else
    label = device.connection ~= "" and device.connection or "Network"
  end

  return {
    connected = true,
    kind = device.kind,
    label = label,
    icon = device.kind == "wifi" and "wifi" or "ethernet-port",
  }
end

local state = signal(empty())
local command = "nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status"

local function refresh(callback)
  awful.spawn.easy_async(command, function(stdout)
    local connected

    for line in stdout:gmatch("[^\r\n]+") do
      local device = parse_device(line)
      if device and device.state:match("^connected") then
        if device.kind == "ethernet" then
          connected = normalize(device)
          break
        end

        if not connected then
          connected = normalize(device)
        end
      end
    end

    state:set(connected or empty())
    if callback then
      callback()
    end
  end)
end

local timer = gears.timer({
  timeout = 15,
  autostart = true,
  call_now = true,
  callback = function()
    refresh()
  end,
})

return {
  state = state,
  refresh = refresh,
  timer = timer,
}
