local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local naughty = require("naughty")
local ruled = require("ruled")

local resize_mode = require("config.resize_mode")

-- Global keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

  -- Client navigation
  awful.key({ modkey }, "h", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus client on left", group = "client" }),
  awful.key({ modkey }, "j", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus client below", group = "client" }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus client above", group = "client" }),
  awful.key({ modkey }, "l", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus client on right", group = "client" }),

  -- Layout manipulation
  awful.key({ modkey }, "r", function()
    resize_mode.start()
  end, { description = "enter resize mode", group = "layout" }),
  awful.key({ modkey }, "s", function()
    awful.layout.inc(1)
  end, { description = "select next layout", group = "layout" }),
  awful.key({ modkey, "Shift" }, "s", function()
    awful.layout.inc(-1)
  end, { description = "select previous layout", group = "layout" }),
  awful.key({ modkey }, "b", function()
    local s = mouse.screen
    s.bar.visible = not s.bar.visible
  end, { description = "toggle bar visibility", group = "layout" }),
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),

  -- Window Switcher
  awful.key({ modkey }, "Tab", function()
    awesome.emit_signal("widgets::window_switcher::show", 1)
  end, { description = "go forward", group = "client" }),
  awful.key({ modkey, "Shift" }, "Tab", function()
    awesome.emit_signal("widgets::window_switcher::show", -1)
  end, { description = "go back", group = "client" }),

  -- Terminal
  awful.key({ modkey }, "Return", function()
    local terminal = "alacritty"
    awful.spawn(terminal, false)
  end, { description = "open a terminal", group = "launcher" }),
  -- rofi
  awful.key({ modkey }, "d", function()
    awful.spawn("rofi -show drun", false)
  end, { description = "run rofi", group = "launcher" }),
  -- Toggle picom
  awful.key({ modkey }, "p", function()
    awful.spawn.with_shell("pgrep -ix picom > /dev/null && killall picom || picom --legacy-backends &")
  end, { description = "toggle picom", group = "misc" }),

  -- Screenshot
  awful.key({}, "Print", function()
    awful.spawn.with_shell("screenshot screen")
  end, { description = "take a screenshot of the active screen", group = "screen" }),
  awful.key({ "Control" }, "Print", function()
    awful.spawn("flameshot gui", false)
  end, { description = "take an area screenshot", group = "screen" }),
  awful.key({ "Shift" }, "Print", function()
    awful.spawn.with_shell("screenshot selection")
  end, { description = "take a screenshot of a specific window", group = "screen" }),
  awful.key({ "Control", "Shift" }, "Print", function()
    helpers.misc.take_screenshot(32)
  end, { description = "take a screenshot of a specific window with padding", group = "screen" }),
  awful.key({ "Mod1" }, "Print", function()
    awful.spawn.with_shell("screenshot full")
  end, { description = "take a full screenshot", group = "screen" }),
})

-- Volume, Media and Brightness keys
awful.keyboard.append_global_keybindings({
  -- Volume keys
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn.easy_async("wpctl set-volume @DEFAULT_SINK@ 0.05+", function()
      awesome.emit_signal("widgets::volume::show")
    end)
  end, { description = "volume up", group = "volume controls" }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn.easy_async("wpctl set-volume @DEFAULT_SINK@ 0.05-", function()
      awesome.emit_signal("widgets::volume::show")
    end)
  end, { description = "volume down", group = "volume controls" }),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn.easy_async("wpctl set-mute @DEFAULT_SINK@ toggle", function()
      awesome.emit_signal("widgets::volume::show")
    end)
  end, { description = "volume mute", group = "volume controls" }),

  -- Mute
  awful.key({ modkey }, "m", function()
    awful.spawn("wpctl set-mute @DEFAULT_SOURCE@ toggle", false)

    local mic_script = "wpctl get-volume @DEFAULT_SOURCE@ | sed -e 's/Volume: //'"
    awful.spawn.easy_async_with_shell(mic_script, function(stdout)
      local state = stdout:match("MUTED") and "muted" or "unmuted"

      naughty.notification({
        title = "Microphone",
        message = "Microphone " .. state,
        timeout = 1,
      })
    end)
  end, { description = "microphone mute", group = "microphone controls" }),

  -- Media controls
  awful.key({}, "XF86AudioPlay", function()
    awful.spawn("playerctl play-pause", false)
  end, { description = "media play", group = "media controls" }),
  awful.key({}, "XF86AudioNext", function()
    awful.spawn("playerctl next", false)
  end, { description = "media next", group = "media controls" }),
  awful.key({}, "XF86AudioPrev", function()
    awful.spawn("playerctl previous", false)
  end, { description = "media previous", group = "media controls" }),
  awful.key({}, "XF86AudioStop", function()
    awful.spawn("playerctl stop", false)
  end, { description = "media stop", group = "media controls" }),

  -- Brightness controls
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn("brillo -q -u 100000 -A 5", false)
  end, { description = "brightness up", group = "screen" }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn("brillo -q -u 100000 -U 5", false)
  end, { description = "brightness down", group = "screen" }),
})

-- Tag navigation keybindings
awful.keyboard.append_global_keybindings({
  awful.key({
    modifiers = { modkey },
    keygroup = "numrow",
    description = "view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  awful.key({
    modifiers = { modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  }),
  awful.key({
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),
})

-- Client keybindings
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    awful.key({ modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Control" }, "f", function(c)
      c.maximized = not c.maximized
    end, { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Shift" }, "q", function(c)
      c:kill()
    end, { description = "close", group = "client" }),
    awful.key({ modkey, "Shift" }, "f", function(c)
      c.floating = not c.floating
    end, { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c)
      c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),
    awful.key({ modkey }, "c", function(c)
      if c.floating then
        helpers.placement.centered(c)
      end
    end, { description = "center a client", group = "client" }),
    awful.key({ modkey, "Control" }, "a", function(c)
      ruled.client.apply(c)
    end, { description = "apply rules to client", group = "client" }),
    awful.key({ modkey, "Control" }, "s", function(c)
      c.width = 400
      c.height = 300
    end, { description = "apply rules to client", group = "client" }),
  })

  helpers.misc.command_exists("fcitx5", function()
    local Control_L = 37
    local Shift_L = 50
    local Super_L = 133

    -- Input method bindings
    awful.keyboard.append_client_keybindings({
      awful.key({ modkey }, "space", function()
        helpers.input.fcitx_toggle()
      end, { description = "toggle input method", group = "input" }),
      awful.key({ modkey, "Control" }, "space", function()
        -- TODO: Extract to `helpers.input` module
        helpers.input.fcitx_status(function(mode)
          if mode == 2 then
            -- TODO: Improve this to not require manual key ups
            helpers.input.key_up("space")
            helpers.input.key("Hiragana", { Super_L, Control_L })
            -- TODO: Make custom indicator widget similar to the Window Switcher
            naughty.notification({
              app_name = "Mozc",
              title = "Mozc",
              message = "Input method changed to Hiragana",
            })
          end
        end)
      end, { description = "set mozc mode to hiragana", group = "input" }),
      awful.key({ modkey, "Shift" }, "space", function()
        helpers.input.fcitx_status(function(mode)
          if mode == 2 then
            helpers.input.key_up("space")
            helpers.input.key("Katakana", { Super_L, Shift_L })
            naughty.notification({
              app_name = "Mozc",
              title = "Mozc",
              message = "Input method changed to Katakana",
            })
          end
        end)
      end, { description = "set mozc mode to katakana", group = "input" }),
    })
  end)
end)

-- Desktop mousebindings
awful.mouse.append_global_mousebindings( --
  helpers.table.map({ 1, 2, 3 }, function(n)
    return awful.button({ "Any" }, n, function()
      client.focus = nil
    end)
  end)
)

-- Client mousebindings
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings( --
    gears.table.join(
      helpers.table.map({ 1, 2, 3 }, function(n)
        return awful.button({}, n, function(c)
          c:activate({ context = "mouse_click" })
        end)
      end),
      {
        awful.button({ modkey }, 1, function(c)
          c:activate({ context = "mouse_click", action = "mouse_move" })
        end),
        awful.button({ modkey }, 3, function(c)
          c:activate({ context = "mouse_click", action = "mouse_resize" })
        end),
      }
    )
  )
end)
