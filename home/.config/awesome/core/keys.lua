local awful = require("awful")
local naughty = require("naughty")
local ruled = require("ruled")

local helpers = require("helpers")

local input_method = require("core.input_method")

---@param mods string[]
---@param key string
---@param callback fun(...) | string
---@param desc string
---@return unknown
local function bind(mods, key, callback, desc)
  local _callback = callback
  if type(callback) == "string" then
    _callback = function()
      awful.spawn(callback, false)
    end
  end
  return awful.key(mods, key, _callback, { description = desc })
end

---@class BindDef
---@field [1] string[]
---@field [2] string
---@field [3] fun(...) | string
---@field [4] string

---@param group string
---@param keybinds BindDef[]
---@return table
local function key_group(group, keybinds)
  local ret = {}
  for _, def in pairs(keybinds) do
    local kb = bind(def[1], def[2], def[3], def[4])
    kb.group = group
    ret[#ret + 1] = kb
  end
  return ret
end

local unpack = unpack or table.unpack
local function emit(...)
  local args = { ... }
  return function()
    awesome.emit_signal(unpack(args))
  end
end

-- General

awful.keyboard.append_global_keybindings(key_group("general", {
  { { modkey, "Control" }, "r", awesome.restart, "reload awesome" },
}))

-- Client

local function close_window(c)
  c:kill()
end

local function toggle_fullscreen(c)
  c.fullscreen = not c.fullscreen
  c:raise()
end

local function toggle_maximized(c)
  c.maximized = not c.maximized
end

local function toggle_floating(c)
  c.floating = not c.floating
end

local function center_window(c)
  if c.floating then
    helpers.placement.centered(c)
  end
end

local function reapply_rules(c)
  ruled.client.apply(c)
end

local function focus_dir(dir)
  return function()
    awful.client.focus.bydirection(dir)
  end
end

local function swap_dir(dir)
  return function()
    awful.client.swap.bydirection(dir)
  end
end

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings(key_group("client", {
    { { modkey, "Shift" }, "q", close_window, "close" },
    { { modkey }, "f", toggle_fullscreen, "toggle fullscreen" },
    { { modkey, "Control" }, "f", toggle_maximized, "toggle maximized" },
    { { modkey, "Shift" }, "f", toggle_floating, "toggle floating" },
    { { modkey }, "c", center_window, "center client" },
    { { modkey, "Control" }, "a", reapply_rules, "re-apply window rules" },

    { { modkey }, "h", focus_dir("left"), "focus client on the left" },
    { { modkey }, "j", focus_dir("down"), "focus client below" },
    { { modkey }, "k", focus_dir("up"), "focus client above" },
    { { modkey }, "l", focus_dir("right"), "focus client on the right" },

    { { modkey, "Shift" }, "h", swap_dir("left"), "swap with client on the left" },
    { { modkey, "Shift" }, "j", swap_dir("down"), "swap with client below" },
    { { modkey, "Shift" }, "k", swap_dir("up"), "swap with client above" },
    { { modkey, "Shift" }, "l", swap_dir("right"), "swap with client on the right" },
  }))
end)

-- awful.keyboard.append_global_keybindings(key_group("screen", {}))

-- Layout

local function cycle_mwfact()
  local t = awful.screen.focused().selected_tag

  if t then
    local factors = { 0.3333, 0.5, 0.6666 }

    for i, factor in ipairs(factors) do
      if t.master_width_factor == factor then
        t.master_width_factor = factors[(i % #factors) + 1]
        return
      end
    end

    t.master_width_factor = 0.5
  end
end

local function sel_layout(i)
  return function()
    awful.layout.inc(i)
  end
end

local function nmaster(n)
  return function()
    awful.tag.incnmaster(n, nil, true)
  end
end

awful.keyboard.append_global_keybindings(key_group("layout", {
  { { modkey }, "r", cycle_mwfact, "cycle master width factor" },
  { { modkey }, "s", sel_layout(1), "select next layout" },
  { { modkey, "Shift" }, "s", sel_layout(-1), "select previous layout" },

  { { modkey, "Control" }, "h", nmaster(1), "increase the number of master clients" },
  { { modkey, "Control" }, "l", nmaster(-1), "decrease the number of master clients" },
}))

-- Tag

local function view_tag(i)
  return function()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      tag:view_only()
    end
  end
end

local function move_to_tag(i)
  return function()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:move_to_tag(tag)
      end
    end
  end
end

local function toggle_tag(i)
  return function()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end
end

for i = 1, 9 do
  awful.keyboard.append_global_keybindings(key_group("tag", {
    { { modkey }, "#" .. i + 9, view_tag(i), "view tag" },
    { { modkey, "Control" }, "#" .. i + 9, toggle_tag(i), "toggle tag" },
    { { modkey, "Shift" }, "#" .. i + 9, move_to_tag(i), "move to tag" },
  }))
end

-- Launcher

awful.keyboard.append_global_keybindings(key_group("launcher", {
  { { modkey }, "d", emit("shell::launcher::show"), "open launcher" },
  { { modkey }, "Return", "alacritty", "open terminal" },
}))

-- Screenshot

awful.keyboard.append_global_keybindings(key_group("screenshot", {
  { {}, "Print", "sana -c", "take a screenshot of the active screen" },
  { { "Control" }, "Print", "flameshot gui", "take a screenshot with an interactive gui" },
  { { "Shift" }, "Print", "sana -s", "take a screenshot of a selection or window" },
  { { "Mod1" }, "Print", "sana -f", "take a full screenshot" },
}))

-- Shell

local function toggle_bar()
  local s = mouse.screen
  s.bar.visible = not s.bar.visible
end

awful.keyboard.append_global_keybindings(key_group("shell", {
  { { modkey }, "b", toggle_bar, "toggle bar visibility" },

  { { modkey }, "Tab", emit("shell::window_switcher::show", 1), "open window switcher" },
  { { modkey, "Shift" }, "Tab", emit("shell::window_switcher::show", -1), "open window switcher" },
}))

-- Misc

local function toggle_compositor()
  helpers.run.toggle("picom")
end

awful.keyboard.append_global_keybindings(key_group("misc", {
  { { modkey }, "p", toggle_compositor, "toggle compositor" },
}))

-- Volume Controls

---@param v string
local function vol(v)
  return function()
    awful.spawn.easy_async("wpctl set-volume -l 1 @DEFAULT_SINK@ " .. v, function()
      awesome.emit_signal("signal::volume")
    end)
  end
end

local function vol_mute()
  awful.spawn.easy_async("wpctl set-mute @DEFAULT_SINK@ toggle", function()
    awesome.emit_signal("signal::volume")
  end)
end

awful.keyboard.append_global_keybindings(key_group("volume controls", {
  { {}, "XF86AudioRaiseVolume", vol("0.05+"), "increase volume" },
  { {}, "XF86AudioLowerVolume", vol("0.05-"), "decrease volume" },
  { {}, "XF86AudioMute", vol_mute, "mute volume" },
}))

-- Microphone

local mic_script = "wpctl set-mute @DEFAULT_SOURCE@ toggle && wpctl get-volume @DEFAULT_SOURCE@"

local function mic_mute()
  awful.spawn.easy_async_with_shell(mic_script, function(stdout)
    local state = stdout:match("MUTED") and "muted" or "unmuted"

    naughty.notification({
      title = "Microphone",
      message = "Microphone " .. state,
      timeout = 1,
    })
  end)
end

awful.keyboard.append_global_keybindings(key_group("microphone", {
  { { modkey }, "m", mic_mute, "microphone mute" },
}))

-- Media Controls

awful.keyboard.append_global_keybindings(key_group("media controls", {
  { {}, "XF86AudioPlay", "playerctl play-pause", "media play/pause" },
  { {}, "XF86AudioNext", "playerctl next", "media next" },
  { {}, "XF86AudioPrev", "playerctl previous", "media previous" },
  { {}, "XF86AudioStop", "playerctl stop", "media stop" },
}))

-- Brightness

awful.keyboard.append_global_keybindings(key_group("brightness", {
  { {}, "XF86MonBrightnessUp", "brillo -q -u 100000 -A 5", "brightness up" },
  { {}, "XF86MonBrightnessDown", "brillo -q -u 100000 -U 5", "brightness down" },
}))

-- Input Method

awful.keyboard.append_global_keybindings(key_group("input method", {
  { { modkey }, "space", input_method.toggle, "toggle input method" },
  { { modkey, "Control" }, "space", input_method.hiragana, "set mozc mode to hiragana" },
  { { modkey, "Shift" }, "space", input_method.katakana, "set mozc mode to katakana" },
}))

-- Mouse buttons

local function unfocus_client()
  client.focus = nil
end

awful.mouse.append_global_mousebindings({
  awful.button({ "Any" }, 1, unfocus_client),
  awful.button({ "Any" }, 2, unfocus_client),
  awful.button({ "Any" }, 3, unfocus_client),
})

---@param action? string
local function activate_client(action)
  return function(c)
    c:activate({ context = "mouse_click", action = action })
  end
end

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, activate_client(nil)),
    awful.button({}, 2, activate_client(nil)),
    awful.button({}, 3, activate_client(nil)),

    awful.button({ modkey }, 1, activate_client("mouse_move")),
    awful.button({ modkey }, 3, activate_client("mouse_resize")),
  })
end)
