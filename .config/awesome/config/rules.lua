local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")
local naughty = require("naughty")

local helpers = require("helpers")

ruled.client.connect_signal("request::rules", function()
  local screen_count = screen.count()
  local leftmost_screen = awful.screen.getbycoord(0, 0)

  -- All clients will match this rule.
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      screen = awful.screen.preferred,
      -- placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      titlebars_enabled = false,
    },
  })

  -- Floating clients.
  ruled.client.append_rule({
    id = "floating",
    rule_any = {
      class = {
        "Arandr",
        "Blueman-manager",
        "Nm-connection-editor",
        "qjoypad",
        "Steam",
        "Thunar",
        "zoom",
      },
      instance = {
        "Devtools",
      },
      role = {
        "devtools",
      },
    },
    properties = {
      floating = true,
    },
  })

  -- Apps with titlebars enabled
  ruled.client.append_rule({
    id = "titlebars_enabled",
    rule = {
      class = "holocure.exe",
    },
    properties = {
      titlebars_enabled = true,
    },
  })

  ruled.client.append_rule({
    id = "discord",
    rule = {
      class = "discord",
    },
    properties = {
      floating = true,
      width = 1600,
      height = 900,
      screen = leftmost_screen,
      tag = screen_count > 1 and "1" or "9",
    },
  })

  ruled.client.append_rule({
    id = "steam",
    rule = {
      name = "Steam",
    },
    properties = {
      floating = true,
      width = 1600,
      height = 900,
    },
  })

  ruled.client.append_rule({
    id = "spotify",
    rule = {
      class = "Spotify",
    },
    properties = {
      floating = true,
      placement = helpers.placement.centered,
      width = 1600,
      height = 900,
    },
  })

  ruled.client.append_rule({
    id = "anime-game-launcher",
    rule = {
      class = "An Anime Game Launcher",
    },
    properties = {
      floating = true,
      placement = helpers.placement.centered,
    },
  })

  ruled.client.append_rule({
    id = "minecraft",
    rule = {
      class = "Minecraft.*",
    },
    properties = {
      floating = true,
      fullscreen = false,
      placement = helpers.placement.centered,
      width = 1280,
      height = 720,
    },
  })

  local function late_apply_rules(c)
    if c.class then
      ruled.client.apply(c)
      c:disconnect_signal("property::class", late_apply_rules)
    end
  end

  -- A workaround for clients that spawn without a class but are assigned a class later
  client.connect_signal("manage", function(c)
    if not c.class then
      c:connect_signal("property::class", late_apply_rules)
    end
  end)
end)
