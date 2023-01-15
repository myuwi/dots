local awful = require("awful")
local cairo = require("lgi").cairo
local gears = require("gears")
local helpers = require("helpers")
local menubar_utils = require("menubar.utils")
local ruled = require("ruled")

-- TODO: Use a fallback if a client doesn't have an icon
local function find_client_icon(c)
  local icon = menubar_utils.lookup_icon(c.class)

  -- Try to "correct" the class to find the icon
  if not icon and c.class:find("[%s%u]") then
    -- Make lowercase and replace spaces with "-"
    local name = string.lower(c.class):gsub("%s+", "-")
    icon = menubar_utils.lookup_icon(name)
  end

  return icon
end

-- Try to find missing client icon
local function set_fallback_icon(c)
  if c and c.valid and c.class and not c.icon then
    local app_icon = find_client_icon(c)

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

client.connect_signal("manage", function(c)
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

  -- A workaround for applying rules to clients that spawn without a class but are assigned a class later
  if not c.class then
    c:connect_signal("property::class", late_apply_rules)
  end

  -- Add icon for clients that don't have it
  if not c.icon then
    if c.class then
      set_fallback_icon(c)
    else
      -- Apply icon to client when it gets a class
      c:connect_signal("property::class", late_apply_icon)
    end
  end
end)

-- Send clients to bottom of the z-order when they are minimized
client.connect_signal("property::minimized", function(c)
  c:lower()
end)
