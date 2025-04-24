local gtimer = require("gears.timer")
local wibox = require("wibox")

function battery_status()
  local acpi = io.popen("acpi -b")

  if acpi == nil then
    return nil
  end

  local status, charge_str, _ = string.match(acpi:read(), "Battery 0: ([%a%s]+), (%d?%d?%d)%%,?(.*)")
  acpi:close()

  if status == nil or charge_str == nil then
    return nil
  end

  local charging = status ~= "Discharging"

  return (charging and "Charging " or "") .. charge_str .. "%"
end

local battery = function()
  local status = battery_status()
  if status == nil then
    return nil
  end

  local battery_text = wibox.widget.textbox(status)

  gtimer({
    timeout = 5,
    autostart = true,
    callback = function()
      battery_text:set_text(battery_status())
    end,
  })

  local battery_widget = wibox.widget({
    battery_text,
    widget = wibox.container.place,
  })

  return battery_widget
end

return battery
