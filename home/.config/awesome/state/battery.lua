local gtimer = require("gears.timer")
local upower = require("lgi").UPowerGlib
local signal = require("lib.signal")

local battery_state = signal(nil)

local display_device = upower.Client():get_display_device()

local upower_state = {
  [upower.DeviceState.UNKNOWN] = "N/A",
  [upower.DeviceState.CHARGING] = "Charging",
  [upower.DeviceState.DISCHARGING] = "Discharging",
  [upower.DeviceState.EMPTY] = "N/A",
  [upower.DeviceState.FULLY_CHARGED] = "Full",
  [upower.DeviceState.PENDING_CHARGE] = "Charging",
  [upower.DeviceState.PENDING_DISCHARGE] = "Discharging",
}

local function update_state(device)
  local prev = battery_state:get()
  if not prev or prev.percentage ~= device.percentage or prev.state ~= device.state then
    battery_state:set({
      percentage = math.floor(device.percentage),
      state = math.floor(device.state),
      state_text = upower_state[device.state],
    })
  end
end

if display_device then
  gtimer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function()
      update_state(display_device)
    end,
  })

  -- FIXME: Doesn't do anything for some reason
  -- display_device.on_notify = update_state
end

return battery_state
