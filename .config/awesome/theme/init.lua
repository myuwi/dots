local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme_path = config_dir .. "theme"

local theme = {}

theme.font_name = "SF Pro"
theme.font_name_bold = "SF Pro Display Bold"
theme.font_size = 9

theme.font = theme.font_name .. " " .. theme.font_size
theme.font_bold = theme.font_name_bold .. " " .. theme.font_size

theme.wallpaper = theme_path .. "/wallpaper.jpg"

-- https://rosepinetheme.com/palette
local colors = {
  base = "#191724",
  text = "#e0def4",
  surface = "#1f1d2e",
  overlay = "#26233a",
  muted = "#6e6a86",
  subtle = "#908caa",
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ebbcba",
  pine = "#31748f",
  foam = "#9ccfd8",
  iris = "#c4a7e7",
  highlight_high = "#524f67",
  highlight_med = "#403d52",
  highlight_low = "#21202e",
  transparent = "#00000000",
}

theme.colors = colors

theme.bg_normal = colors.base
theme.bg_focus = colors.overlay
theme.bg_urgent = colors.love
theme.bg_minimize = colors.transparent
theme.bg_panel = colors.base
theme.bg_systray = theme.bg_panel

theme.fg_normal = colors.text
theme.fg_focus = colors.text
theme.fg_urgent = colors.text
theme.fg_minimize = colors.text .. "66"

theme.useless_gap = dpi(4)
theme.border_width = dpi(0)
theme.border_radius = dpi(4)

-- Tasklist
theme.tasklist_bg_focus = colors.overlay
theme.bg_tasklist_active = colors.overlay
theme.bg_tasklist_inactive = "#00000000"

theme.tasklist_plain_task_name = true

theme.systray_icon_spacing = dpi(4)

theme.notification_margin = dpi(16)
theme.notification_spacing = dpi(8)

theme.menu_submenu_icon = theme_path .. "default/submenu.png"
theme.menu_height = dpi(32)
theme.menu_width = dpi(100)

theme.layout_max = theme_path .. "/layouts/maxw.png"
theme.layout_tile = theme_path .. "/layouts/tilew.png"

theme.icon_theme = "Papirus"

beautiful.init(theme)
