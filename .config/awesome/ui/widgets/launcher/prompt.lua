local awful = require("awful")
local gtable = require("gears.table")

local prompt = { mt = {} }

function prompt:reset()
  self.text = ""

  if self.changed_callback then
    self.changed_callback(self.text)
  end
end

function prompt:start()
  self._private.keygrabber = awful.keygrabber({
    mask_modkeys = true,
    keypressed_callback = function(_, mod, key, event)
      if self.keypressed_callback then
        self.keypressed_callback(mod, key, event)
      end

      if event == "release" then
        return
      end

      if key == "BackSpace" then
        self.text = self.text:sub(1, -2)
      end

      if key:wlen() == 1 then
        self.text = self.text .. key
      end

      if self.changed_callback then
        self.changed_callback(self.text)
      end
    end,
  })

  self._private.keygrabber:start()
end

function prompt:stop()
  self._private.keygrabber:stop()
end

---@class (exact) PromptArgs
---@field text string?
---@field keypressed_callback fun(mod, key: string, event: string): any
---@field changed_callback fun(text: string): any

---@param args PromptArgs
local function new(args)
  args.text = args.text or ""

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
