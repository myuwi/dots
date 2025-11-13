local awful = require("awful")
local cairo = require("lgi").cairo
local gears = require("gears")
local ruled = require("ruled")

local helpers = require("helpers")

-- Try to find missing client icon
local function set_fallback_icon(c)
  if c and c.valid and c.class and not c.icon then
    local app_icon = helpers.client.find_icon(c.class)

    -- Set client icon
    if app_icon then
      local s = gears.surface(app_icon)
      local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
      local cr = cairo.Context(img)
      cr:set_source_surface(s, 0, 0)
      cr:paint()

      c.icon = img._native
    end
  end
end

local function late_apply_icon(c)
  if c.class then
    if not c.icon then
      set_fallback_icon(c)
    end
    if c.icon then
      c:disconnect_signal("property::class", late_apply_icon)
    end
  end
end

local function late_apply_rules(c)
  if c.class then
    ruled.client.apply(c)
    c:disconnect_signal("property::class", late_apply_rules)
  end
end

local function intercept_floating_geometry_change(c)
  if not c.floating then
    c.floating_geometry = nil
  end
end

-- Don't set floating geometry on clients that aren't floating.
-- Fixes an inconsistency in when floating_geometry is set for clients with and without borders.
-- See: https://github.com/awesomeWM/awesome/blob/b54e50ad6cfdcd864a21970b31378f7c64adf3f4/lib/awful/client.lua#L864
client.connect_signal("property::floating_geometry", intercept_floating_geometry_change)

client.connect_signal("request::manage", function(c)
  if not awesome.startup then
    -- Spawn new clients as slaves
    awful.client.setslave(c)

    -- Center windows when they are spawned
    if c.floating and not c.size_hints.user_position and not c.size_hints.program_position then
      helpers.placement.centered(c)
    end
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- A workaround for applying rules to clients that spawn without a class but are assigned one later
  if not c.class then
    c:connect_signal("property::class", late_apply_rules)
  end

  -- Try to add icon for clients that don't have it
  if not c.icon then
    if c.class then
      set_fallback_icon(c)
    else
      -- Apply icon to client when it gets a class
      c:connect_signal("property::class", late_apply_icon)
    end
  end
end)

-- Raise clients when they are focused
client.connect_signal("focus", function(c)
  c:raise()
end)

-- Send clients to bottom of the z-order when they are minimized
client.connect_signal("property::minimized", function(c)
  c:lower()
end)

-- Disable stacked shadows in max layout
screen.connect_signal("arrange", function(s)
  local visible_clients = helpers.table.filter(client.get(s, true), function(c)
    return c.first_tag.selected
  end)

  for i, c in ipairs(visible_clients) do
    local disable_shadow = (s.selected_tag and s.selected_tag.layout.name == "max") and i > 1

    if disable_shadow then
      helpers.window.set_prop(c, "_SHADOW_DISABLE", 1)
    else
      helpers.window.set_prop(c, "_SHADOW_DISABLE", 0)
    end
  end
end)
