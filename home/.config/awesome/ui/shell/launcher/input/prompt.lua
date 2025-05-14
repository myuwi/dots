local awful = require("awful")
local gtable = require("gears.table")

local prompt = { mt = {} }

local function cursor_backward(self)
  self.cursor_pos = math.max(self.cursor_pos - 1, 0)
end

local function cursor_forward(self)
  self.cursor_pos = math.min(self.cursor_pos + 1, self.text:wlen())
end

function prompt:start()
  self._private.keygrabber = awful.keygrabber({
    mask_modkeys = true,
    keypressed_callback = function(_, mod, key)
      if self.keypressed_callback then
        self.keypressed_callback(mod, key)
      end

      if key == "BackSpace" then
        self.text = self.text:sub(1, math.max(self.cursor_pos - 1, 0)) .. self.text:sub(self.cursor_pos + 1)
        cursor_backward(self)
      elseif key == "Delete" then
        self.text = self.text:sub(1, self.cursor_pos) .. self.text:sub(self.cursor_pos + 2)
      end

      if key == "Left" then
        cursor_backward(self)
      elseif key == "Right" then
        cursor_forward(self)
      end

      if key:wlen() == 1 then
        self.text = self.text:sub(1, self.cursor_pos) .. key .. self.text:sub(self.cursor_pos + 1)
        cursor_forward(self)
      end

      if self.changed_callback then
        self.changed_callback(self.text, self.cursor_pos)
      end
    end,
  })

  self._private.keygrabber:start()
end

function prompt:stop()
  self._private.keygrabber:stop()
end

function prompt:reset()
  self.text = ""

  if self.changed_callback then
    self.changed_callback(self.text)
  end
end

---@class (exact) PromptArgs
---@field text string?
---@field cursor_pos integer? The number of characters on the left side of the cursor
---@field keypressed_callback fun(mod, key: string): any
---@field changed_callback fun(text: string, cursor_pos: integer): any

---@param args PromptArgs
local function new(args)
  args = args or {}
  args.text = args.text or ""
  args.cursor_pos = args.cursor_pos or 0

  local ret = {}
  ret._private = {}
  gtable.crush(ret, prompt)
  gtable.crush(ret, args)

  return ret
end

function prompt.mt:__call(...)
  return new(...)
end

return setmetatable(prompt, prompt.mt)
