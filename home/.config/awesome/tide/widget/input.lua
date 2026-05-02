local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gcolor = require("gears.color")
local gstring = require("gears.string")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local wibox = require("wibox")

local text = require("tide.widget.text")

local input = { mt = {} }

local function utf8_len(str)
  return utf8.len(str) or 0
end

local function clamp_cursor(text_value, cursor_position)
  return math.max(0, math.min(cursor_position or 0, utf8_len(text_value)))
end

local function cursor_byte_index(text_value, cursor_position)
  if cursor_position <= 0 then
    return 1
  end

  return utf8.offset(text_value, cursor_position + 1) or (#text_value + 1)
end

local function sync_display_text(self)
  local display_text = self._private.input_text
  local display_color = self._private.input_color

  if display_text == "" then
    display_text = self._private.placeholder
    display_color = beautiful.fg_placeholder
  end

  self._private.markup = nil
  self._private.layout.text = display_text
  self._private.layout.attributes = nil
  self._private.foreground = display_color and gcolor(display_color) or nil
  self:emit_signal("widget::redraw_needed")
end

local function activate_cursor(self)
  self._private.cursor_visible = true
  self._private.cursor_blink_timer:again()
  self:emit_signal("widget::redraw_needed")
end

local function hide_cursor(self)
  self._private.cursor_visible = false
  self._private.cursor_blink_timer:stop()
  self:emit_signal("widget::redraw_needed")
end

local function set_focused(self, focused)
  if self._private.focused == focused then
    return
  end

  self._private.focused = focused

  if focused then
    self._private.keygrabber = awful.keygrabber({
      mask_modkeys = true,
      keypressed_callback = function(_, mods, key)
        self:emit_signal("key::press", mods, key)

        if key == "Escape" then
          self:emit_signal("escape")
        elseif key == "Return" or key == "KP_Enter" then
          self:emit_signal("submit")
        elseif key == "BackSpace" then
          self:delete_backward()
        elseif key == "Delete" then
          self:delete_forward()
        elseif key == "Left" then
          self:move_cursor(-1)
        elseif key == "Right" then
          self:move_cursor(1)
        elseif key == "Home" then
          self:set_cursor_position(0)
        elseif key == "End" then
          self:set_cursor_position(utf8_len(self._private.input_text))
        elseif utf8_len(key) == 1 then
          self:insert_text(key)
        end
      end,
    })

    self._private.keygrabber:start()
    activate_cursor(self)
  else
    if self._private.keygrabber then
      self._private.keygrabber:stop()
      self._private.keygrabber = nil
    end

    hide_cursor(self)
  end

  self:emit_signal("property::focused", focused)
end

function input:set_text(value)
  value = value or ""

  if self._private.input_text == value then
    return
  end

  self._private.input_text = value
  self._private.cursor_position = clamp_cursor(value, self._private.cursor_position)

  sync_display_text(self)

  self:emit_signal("property::text", value)
  self:emit_signal("property::cursor_position", self._private.cursor_position)
  self:emit_signal("widget::redraw_needed")
  self:emit_signal("widget::layout_changed")
end

function input:get_text()
  return self._private.input_text
end

function input:set_placeholder(value)
  value = value or ""

  if self._private.placeholder == value then
    return
  end

  self._private.placeholder = value

  if self._private.input_text == "" then
    sync_display_text(self)
    self:emit_signal("widget::layout_changed")
  end

  self:emit_signal("property::placeholder", value)
  self:emit_signal("widget::redraw_needed")
end

function input:get_placeholder()
  return self._private.placeholder
end

function input:set_cursor_position(value)
  value = clamp_cursor(self._private.input_text, value)

  if self._private.cursor_position == value then
    return
  end

  self._private.cursor_position = value
  activate_cursor(self)
  self:emit_signal("property::cursor_position", value)
end

function input:get_cursor_position()
  return self._private.cursor_position
end

function input:set_focused(value)
  set_focused(self, not not value)
end

function input:get_focused()
  return self._private.focused
end

function input:set_color(color)
  if self._private.input_color == color then
    return
  end

  self._private.input_color = color
  sync_display_text(self)
  self:emit_signal("property::color", color)
end

function input:get_color()
  return self._private.input_color
end

function input:insert_text(value)
  if not value or value == "" then
    return
  end

  local byte_index = cursor_byte_index(self._private.input_text, self._private.cursor_position)
  local new_text = self._private.input_text:sub(1, byte_index - 1) .. value .. self._private.input_text:sub(byte_index)

  self:set_text(new_text)
  self:set_cursor_position(self._private.cursor_position + utf8_len(value))
end

function input:delete_backward()
  if self._private.cursor_position == 0 then
    return
  end

  local cursor_position = self._private.cursor_position
  local from = utf8.offset(self._private.input_text, cursor_position)
  local to = cursor_byte_index(self._private.input_text, cursor_position)
  local new_text = self._private.input_text:sub(1, from - 1) .. self._private.input_text:sub(to)

  self:set_text(new_text)
  self:set_cursor_position(cursor_position - 1)
end

function input:delete_forward()
  if self._private.cursor_position >= utf8_len(self._private.input_text) then
    return
  end

  local from = cursor_byte_index(self._private.input_text, self._private.cursor_position)
  local to = cursor_byte_index(self._private.input_text, self._private.cursor_position + 1)
  local new_text = self._private.input_text:sub(1, from - 1) .. self._private.input_text:sub(to)

  self:set_text(new_text)
end

function input:move_cursor(amount)
  self:set_cursor_position(self._private.cursor_position + amount)
end

function input:focus()
  set_focused(self, true)
end

function input:unfocus()
  set_focused(self, false)
end

function input:reset()
  self:set_text("")
  self:set_cursor_position(0)
end

function input:draw(context, cr, width, height)
  text.draw(self, context, cr, width, height)

  if not self._private.focused or not self._private.cursor_visible then
    return
  end

  local text_before_cursor = self._private.input_text:sub(1, cursor_byte_index(self._private.input_text, self._private.cursor_position) - 1)
  local cursor_x =
    wibox.widget.textbox.get_markup_geometry(gstring.xml_escape(text_before_cursor), screen.primary, self.font).width

  local _, logical = self._private.layout:get_pixel_extents()
  local cursor_y = 0
  if self._private.valign == "center" then
    cursor_y = (height - logical.height) / 2
  elseif self._private.valign == "bottom" then
    cursor_y = height - logical.height
  end

  cr:save()
  cr:set_source(gcolor(self._private.input_color or beautiful.fg_normal))
  cr:rectangle(math.min(cursor_x, width - dpi(1)), cursor_y, dpi(1), logical.height)
  cr:fill()
  cr:restore()
end

local function new()
  local ret = text()
  ret.widget_name = "Input"

  gtable.crush(ret, input, true)

  ret._private.input_text = ""
  ret._private.placeholder = ""
  ret._private.cursor_position = 0
  ret._private.focused = false
  ret._private.cursor_visible = false
  ret._private.input_color = nil
  ret._private.cursor_blink_timer = gtimer({
    timeout = 0.6,
    autostart = false,
    callback = function()
      ret._private.cursor_visible = not ret._private.cursor_visible
      ret:emit_signal("widget::redraw_needed")
    end,
  })

  sync_display_text(ret)

  return ret
end

function input.mt:__call()
  return new()
end

return setmetatable(input, input.mt)
