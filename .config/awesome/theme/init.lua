local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")

local theme_path = gfs.get_configuration_dir() .. "theme/"

local theme = {}

theme.font_name = "Inter"
theme.font_size = 9
theme.font = theme.font_name .. " " .. theme.font_size

theme.icon_path = theme_path .. "assets/icons/"

-- Source: https://unsplash.com/photos/mthwaeiqky0
theme.wallpaper = theme_path .. "assets/wallpaper.jpg"

local colors = require("theme.colors")

theme.colors = colors

theme.bg_normal = colors.base
theme.bg_focus = colors.overlay
theme.bg_urgent = colors.urgent
theme.bg_minimize = colors.transparent
theme.bg_bar = colors.base
theme.bg_systray = theme.bg_bar

theme.fg_normal = colors.text
theme.fg_focus = colors.text
theme.fg_urgent = colors.text
theme.fg_minimize = colors.text .. "66"

-- Gaps
theme.useless_gap = 6

-- Borders
theme.border_radius = 8
theme.border_color = colors.surface
theme.border_width = 1

-- Bar
--- @type "top" | "bottom"
theme.bar_position = "top"
--- @type number | nil
theme.bar_width = nil
theme.bar_height = 42
theme.bar_gap = theme.useless_gap * 2
theme.bar_padding = dpi(6)
theme.bar_spacing = dpi(6)

-- Calendar
theme.calendar_fg_current = colors.surface
theme.calendar_bg_current = colors.accent
theme.calendar_weekday = colors.subtle
theme.calendar_weeknumber = colors.subtle
theme.calendar_day_other = colors.muted

theme.calendar_spacing = 6
theme.calendar_cell_size = 24
-- Tasklist
theme.tasklist_plain_task_name = true

-- Systray
theme.systray_icon_spacing = dpi(6)

-- Window Switcher
theme.window_switcher_hover = colors.overlay
theme.window_switcher_focus = colors.surface
theme.window_switcher_inactive = colors.transparent

-- Notifications
theme.notification_width = dpi(360)
theme.notification_margin = dpi(16)
theme.notification_spacing = theme.useless_gap * 2

-- Icon theme
theme.icon_theme = "Papirus"

beautiful.init(theme)
