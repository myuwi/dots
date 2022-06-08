local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local themes_path = config_dir .. "theme"

local theme = {}

theme.font_name = "Droid Sans"
theme.font_size = 9
theme.font = theme.font_name .. " " .. theme.font_size

theme.wallpaper = os.getenv("HOME") .. "/Pictures/97177742_p0.jpg"

-- https://rosepinetheme.com/palette
local colors = {
  base = "#191724",
  text = "#e0def4",
  surface = "#1f1d2e",
  overlay = "#26233a",
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ebbcba",
  pine = "#31748f",
  foam = "#9ccfd8",
  highlight_med = "#403d52",
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

theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(32)
theme.menu_width = dpi(100)

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "/layouts/fairvw.png"
theme.layout_floating = themes_path .. "/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "/layouts/magnifierw.png"
theme.layout_max = themes_path .. "/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "/layouts/cornersew.png"

beautiful.init(theme)
