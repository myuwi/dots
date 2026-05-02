local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gtimer = require("gears.timer")
local glib = require("lgi").GLib

local Container = require("tide.widget").Container
local Text = require("tide.widget").Text
local Calendar = require("ui.components").Calendar
local Popover = require("ui.components").Popover

local signal = require("tide.signal")
local computed = require("tide.signal.computed")

local DateTime = glib.DateTime
local TimeZone = glib.TimeZone

local function calc_timeout(refresh)
  return refresh - os.time() % refresh
end

local function create_time_signal(format)
  local refresh = 60
  local time = signal("")
  local timer

  local function update()
    local str = DateTime.new_now(TimeZone.new_local()):format(format)
    timer.timeout = calc_timeout(refresh)
    timer:again()
    time:set(str)
    return true
  end

  timer = gtimer.start_new(refresh, update)

  update()

  return time
end

local time = create_time_signal("%d %b %H:%M")

local function clock(_)
  local calendar = Calendar {}

  return Popover {
    placement = "bottom",
    on_open_change = function(visible)
      if visible then
        calendar:reset()
      end
    end,

    trigger = function(state)
      return Container {
        bg = computed(function()
          return state.open:get() and beautiful.bg_bar_item_focus or nil
        end),
        radius = dpi(4),
        padding = { x = dpi(8) },
        on_button_press = function(_, _, _, button)
          if button == 1 then
            state.toggle()
          end
        end,

        Text { text = time },
      }
    end,

    content = calendar,
  }
end

return clock
