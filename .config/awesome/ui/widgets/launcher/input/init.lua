local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gstring = require("gears.string")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local wibox = require("wibox")

local prompt = require(... .. ".prompt")

local input = { mt = {} }

local function activate_cursor(self)
  self._private.cursor.visible = true
  self._private.cursor_blink_timer:again()
end

local function hide_cursor(self)
  self._private.cursor.visible = false
  self._private.cursor_blink_timer:stop()
end

function input:focus()
  self._private.prompt:start()
  activate_cursor(self)
end

function input:unfocus()
  self._private.prompt:stop()
  hide_cursor(self)
end

function input:reset()
  self._private.prompt:reset()
end

---@class (exact) InputArgs
---@field text string?
---@field placeholder string?
---@field keypressed_callback fun(mod, key: string, event: string): any
---@field changed_callback fun(text: string): any

---@param args InputArgs
local function new(args)
  args = args or {}
  args.text = args.text or ""
  args.placeholder = args.placeholder or ""

  -- TODO: scroll instead of ellipsis on overflow
  local textbox = wibox.widget.textbox()
  local placeholder = wibox.widget.textbox(args.placeholder)

  local cursor = wibox.widget({
    forced_width = dpi(1),
    forced_height = dpi(14),
    point = { x = 0, y = dpi(2) },
    bg = beautiful.colors.text,
    widget = wibox.container.background,
  })

  local cursor_positioner = wibox.widget({
    cursor,
    layout = wibox.layout.manual,
  })

  local w = wibox.widget({
    placeholder,
    textbox,
    cursor_positioner,
    forced_height = dpi(18),
    layout = wibox.layout.stack,
  })

  w._private.textbox = textbox
  w._private.placeholder = placeholder
  w._private.cursor = cursor

  w._private.cursor_blink_timer = gtimer({
    -- Same as GNOME's default cursor-blink-time
    timeout = 0.6,
    callback = function()
      w._private.cursor.visible = not w._private.cursor.visible
    end,
  })

  gtable.crush(w, input)
  gtable.crush(w, args)

  w._private.prompt = prompt({
    keypressed_callback = function(mod, key)
      if w.keypressed_callback then
        w.keypressed_callback(mod, key)
      end
    end,
    changed_callback = function(text, cursor_pos)
      w._private.placeholder.visible = text == ""
      w._private.textbox.text = text
      w.text = text

      local text_before_cursor = text:sub(1, cursor_pos)
      local text_before_cursor_width =
        wibox.widget.textbox.get_markup_geometry(gstring.xml_escape(text_before_cursor)).width

      cursor_positioner:move_widget(w._private.cursor, function(_, a)
        return {
          x = math.min(text_before_cursor_width, a.parent.width),
          y = dpi(2),
        }
      end)

      activate_cursor(w)

      if w.changed_callback then
        w.changed_callback(w._private.textbox.text)
      end
    end,
  })

  w._private.prompt:reset()

  return w
end

function input.mt:__call(...)
  return new(...)
end

return setmetatable(input, input.mt)
