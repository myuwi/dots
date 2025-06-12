local gtimer = require("gears.timer")
local Text = require("ui.widgets").Text

function read_file(path)
  local file = io.open(path, "r")

  if not file then
    return nil
  end

  local content = file:read()
  file:close()

  return content
end

function battery_status()
  local capacity = read_file("/sys/class/power_supply/BAT0/capacity")
  local status = read_file("/sys/class/power_supply/BAT0/status")

  if status == nil or capacity == nil then
    return nil
  end

  local status_text = status == "Full" and "Charged " or status ~= "Discharging" and status .. " " or ""

  return status_text .. capacity .. "%"
end

local function battery()
  local status = battery_status()
  if status == nil then
    return nil
  end

  local battery_widget = Text { status }

  gtimer({
    timeout = 5,
    autostart = true,
    callback = function()
      battery_widget:set_text(battery_status())
    end,
  })

  return battery_widget
end

return battery
