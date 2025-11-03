local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")

local hcolor = require("helpers.color")

local theme_path = gfs.get_configuration_dir() .. "theme/"

local theme = {}

theme.font_name = "Inter"
theme.font_size = 8.5
theme.font = theme.font_name .. " " .. theme.font_size

theme.icon_path = theme_path .. "assets/icons/"

-- Source: https://unsplash.com/photos/mthwaeiqky0
theme.wallpaper = theme_path .. "assets/wallpaper.jpg"

local colors = require("theme.colors")

theme.colors = colors

theme.bg_normal = colors.base
theme.bg_focus = hcolor.opacity(colors.muted, 0.15)
theme.bg_hover = hcolor.opacity(colors.muted, 0.25)
theme.bg_urgent = colors.urgent
theme.bg_minimized = nil
theme.bg_bar = colors.base
theme.bg_systray = theme.bg_bar

theme.fg_normal = colors.text
theme.fg_focus = colors.text
theme.fg_urgent = colors.text
theme.fg_muted = colors.muted
theme.fg_minimized = colors.muted
theme.fg_unfocus = colors.muted
theme.fg_placeholder = colors.muted

theme.bg_button = theme.bg_focus
theme.bg_button_hover = theme.bg_hover

-- Gaps
theme.useless_gap = dpi(6)

-- Borders
theme.border_radius = dpi(6)
theme.border_color = colors.surface
theme.border_width = dpi(1)

theme.border_focus = hcolor.opacity(colors.muted, 0.2)
theme.border_hover = hcolor.opacity(colors.muted, 0.3)

-- Bar
theme.bar_height = dpi(42)
theme.bar_padding = dpi(6)
theme.bar_spacing = dpi(6)

-- Calendar
theme.calendar_fg_current = colors.surface
theme.calendar_bg_current = colors.accent
theme.calendar_weekday = colors.subtle
theme.calendar_weeknumber = colors.subtle
theme.calendar_day_other = colors.muted

theme.calendar_spacing = dpi(6)
theme.calendar_cell_size = dpi(24)

-- Tasklist
theme.tasklist_plain_task_name = true

-- Systray
theme.systray_icon_spacing = dpi(6)

-- Window Switcher
theme.window_switcher_focus = theme.bg_focus
theme.window_switcher_hover = theme.bg_hover
theme.window_switcher_inactive = nil

-- Notifications
theme.notification_width = dpi(360)
theme.notification_margin = dpi(18)
theme.notification_spacing = theme.useless_gap * 2

-- Icon theme
theme.icon_theme = "Papirus"

beautiful.init(theme)
