local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gfs = require("gears.filesystem")

local theme_path = gfs.get_configuration_dir() .. "theme/"

local theme = {}

theme.font_name = "Inter"
theme.font_size = 9
theme.font = theme.font_name .. " " .. theme.font_size

theme.icon_path = theme_path .. "assets/icons/"

-- Source: https://unsplash.com/photos/shRafhEd6Dw
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

theme.client_border_width = 0
theme.widget_border_width = 0

-- Bar
--- @type "top" | "bottom"
theme.bar_position = "top"
--- @type number | nil
theme.bar_width = nil
theme.bar_height = 42
theme.bar_gap = theme.useless_gap * 2
theme.bar_padding = dpi(6)
theme.bar_spacing = dpi(6)

-- Tasklist
theme.bg_tasklist_active = colors.overlay
theme.bg_tasklist_minimized = "#00000000"
theme.bg_tasklist_inactive = "#00000000"

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

-- Menu
theme.menu_submenu_icon = theme_path .. "assets/submenu.png"
theme.menu_height = dpi(32)
theme.menu_width = dpi(100)

-- Layouts
theme.layout_max = theme_path .. "assets/layouts/maxw.png"
theme.layout_tile = theme_path .. "assets/layouts/tilew.png"

-- Icon theme
theme.icon_theme = "Papirus"

beautiful.init(theme)
