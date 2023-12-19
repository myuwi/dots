local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
  local screen_count = screen.count()
  local leftmost_screen = awful.screen.getbycoord(0, 0)

  -- All clients will match this rule.
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      border_width = beautiful.client_border_width,
      border_color = beautiful.border_color,
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
      name = {
        "ArmCord Settings | Version:",
      },
      class = {
        "An Anime Game Launcher",
        "Arandr",
        "Blueman-manager",
        "Nm-connection-editor",
        "qjoypad",
        "leagueclientux.exe",
        "Thunar",
      },
      role = {
        "item-selector",
      },
    },
    properties = {
      floating = true,
    },
  })

  -- On-top clients.
  ruled.client.append_rule({
    id = "on-top",
    rule_any = {
      role = {
        "gimp-toolbox-color-dialog",
      },
    },
    properties = {
      ontop = true,
    },
  })

  -- Apps with titlebars enabled
  ruled.client.append_rule({
    id = "titlebars_enabled",
    rule_any = {
      class = {
        -- "holocure.exe",
        -- "holocurelauncher.exe",
      },
    },
    properties = {
      titlebars_enabled = true,
    },
  })

  ruled.client.append_rule({
    id = "discord",
    rule_any = {
      class = {
        "ArmCord",
        "discord",
      },
    },
    except_any = {
      name = { "ArmCord Settings | Version:" },
      role = { "devtools" },
    },
    properties = {
      placement = helpers.placement.centered,
      floating = true,
      width = 1600,
      height = 900,
      screen = leftmost_screen,
      tag = screen_count > 1 and "1" or "9",
    },
  })

  ruled.client.append_rule({
    id = "megasync",
    rule = {
      class = "MEGAsync",
    },
    properties = {
      floating = true,
      placement = function(c)
        awful.placement.top_right(c, {
          offset = {
            x = -beautiful.useless_gap * 2,
            y = beautiful.useless_gap * 2,
          },
          honor_workarea = true,
        })
      end,
      screen = 1,
    },
  })

  ruled.client.append_rule({
    id = "steam",
    rule_any = {
      class = {
        "steam",
      },
    },
    properties = {
      floating = true,
    },
  })

  ruled.client.append_rule({
    id = "steam-main",
    rule = {
      class = "steam",
      name = "Steam",
    },
    properties = {
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
      width = 1600,
      height = 900,
    },
  })

  -- Zoom
  ruled.client.append_rule({
    id = "zoom",
    rule = {
      class = "zoom",
    },
    except = {
      name = "Zoom Meeting",
    },
    properties = {
      floating = true,
    },
  })

  ruled.client.append_rule({
    id = "zoom-main",
    rule = {
      class = "zoom",
      name = "Zoom Meeting",
    },
    properties = {
      floating = false,
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
end)
