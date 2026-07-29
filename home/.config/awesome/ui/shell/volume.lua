local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local computed = require("tide.signal.computed")

local Popup = require("ui.popup")
local Row = require("tide.widget").Row
local Flexible = require("tide.widget").Flexible
local ProgressBar = require("tide.widget").ProgressBar
local Text = require("tide.widget").Text
local Icon = require("ui.components").Icon

local audio_state = require("state.audio")

local volume_icon = Icon {
  size = dpi(18),
  computed(function()
    return audio_state.state:get().icon
  end),
}

local volume_bar = ProgressBar {
  shape = gears.shape.rounded_bar,
  bar_shape = gears.shape.rounded_bar,
  color = beautiful.fg_focus,
  background_color = beautiful.bg_focus,
  max_value = 100,
  value = computed(function()
    return audio_state.state:get().volume
  end),
  forced_height = dpi(6),
}

local volume_text = Text {
  text = computed(function()
    return tostring(audio_state.state:get().volume)
  end),
  halign = "center",
  valign = "center",
  forced_width = dpi(18),
  forced_height = dpi(18),
}

local volume_widget = Popup {
  padding = dpi(18),
  forced_width = dpi(288),
  placement = function(w)
    awful.placement.bottom(w, {
      margins = beautiful.useless_gap * 4,
      honor_workarea = true,
    })
  end,

  Row {
    align_items = "center",
    spacing = dpi(12),

    volume_icon,
    Flexible {
      grow = 1,
      volume_bar,
    },
    volume_text,
  },
}

volume_widget:set_xproperty("_WM_TRANSITION", "slide-up")

local hide_volume_widget = gears.timer({
  timeout = 1,
  autostart = false,
  single_shot = true,
  callback = function()
    volume_widget.visible = false
  end,
})

volume_widget.buttons = {
  awful.button({ "Any" }, 3, function()
    volume_widget.visible = false
    hide_volume_widget:stop()
  end),
}

awesome.connect_signal("signal::volume", function()
  audio_state.refresh(function()
    if volume_widget.visible then
      hide_volume_widget:again()
    else
      volume_widget.visible = true
      hide_volume_widget:start()
    end
  end)
end)
