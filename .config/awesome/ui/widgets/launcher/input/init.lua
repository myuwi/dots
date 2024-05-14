local gstring = require("gears.string")
local gtable = require("gears.table")
local wibox = require("wibox")

local prompt = require(... .. ".prompt")

local input = { mt = {} }

function input:focus()
  self._private.prompt:start()
end

function input:unfocus()
  self._private.prompt:stop()
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

  local textbox = wibox.widget.textbox()
  local placeholder = wibox.widget.textbox(args.placeholder)

  local w = wibox.widget({
    textbox,
    placeholder,
    layout = wibox.layout.fixed.horizontal,
  })

  w._private.textbox = textbox
  w._private.placeholder = placeholder

  gtable.crush(w, input)
  gtable.crush(w, args)

  w._private.prompt = prompt({
    keypressed_callback = function(mod, key)
      if w.keypressed_callback then
        w.keypressed_callback(mod, key)
      end
    end,
    changed_callback = function(text)
      w._private.placeholder.visible = text == ""
      w._private.textbox.markup = gstring.xml_escape(text)
      w.text = text

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
