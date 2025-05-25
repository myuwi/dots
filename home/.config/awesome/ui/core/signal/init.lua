local gtable = require("gears.table")
local context = require("ui.core.signal.internal.context")

---@alias OnSubscribeCallback fun(): nil
---@alias SignalCallback fun(value: unknown): nil

---@class Signal
---@field value unknown
---@field private _on_subscribe_callbacks OnSubscribeCallback[]
---@field private _subscribers SignalCallback[]
---@field private _value any
---@field private __type "Signal"
local Signal = {}

Signal.__type = "Signal"

---@return boolean # A boolean value indicating whether this signal has active subscribers
function Signal:has_subscribers()
  return #self._subscribers > 0
end

---@param callback OnSubscribeCallback Add a new callback to call when a new subscription is made (called before invoking subscribe callback)
function Signal:on_subscribe(callback)
  table.insert(self._on_subscribe_callbacks, callback)
end

---@param callback SignalCallback A callback function to invoke when the signal's value changes
---@param immediate? boolean Invoke the callback immediately (default: true)
---@return fun(): nil unsubscribe A function to unsubscribe the callback from the signal
function Signal:subscribe(callback, immediate)
  immediate = immediate == nil and true or immediate

  table.insert(self._subscribers, callback)

  for _, subscribe_callback in ipairs(self._on_subscribe_callbacks) do
    subscribe_callback()
  end

  if immediate then
    callback(self._value)
  end

  local function unsubscribe()
    self:unsubscribe(callback)
  end

  -- Register cleanup in current reactive scope (if any)
  local current_scope = context.current()
  if current_scope then
    current_scope:on_cleanup(unsubscribe)
  end

  return unsubscribe
end

---@param callback SignalCallback A callback function to unsubscribe from the signal
function Signal:unsubscribe(callback)
  for i, fn in ipairs(self._subscribers) do
    if fn == callback then
      table.remove(self._subscribers, i)
      break
    end
  end
end

---@private
function Signal:get_value()
  local current_scope = context.current()
  if current_scope and current_scope.invalidate then
    self:subscribe(current_scope.invalidate, false)
  end

  return self._value
end

local unpack = unpack or table.unpack
---@private
function Signal:set_value(value)
  if self._value ~= value then
    self._value = value

    local subs_copy = { unpack(self._subscribers) }
    for _, notify_callback in ipairs(subs_copy) do
      notify_callback(self._value)
    end
  end
end

---Create a new signal
---@param initial_value any
---@return Signal
local function new(initial_value)
  local ret = {
    _value = initial_value,
    _on_subscribe_callbacks = {},
    _subscribers = {},
  }

  gtable.crush(ret, Signal, true)

  setmetatable(ret, {
    __index = function(self, key)
      if rawget(self, "get_" .. key) then
        return self["get_" .. key](self)
      else
        return rawget(self, key)
      end
    end,
    __newindex = function(self, key, value)
      if rawget(self, "set_" .. key) then
        self["set_" .. key](self, value)
      else
        rawset(self, key, value)
      end
    end,
  })

  return ret
end

---@class SignalModule
---@field private mt table
local M = { mt = {} }

---Checks if the given value is a signal
---@param value any
---@return boolean
function M.is_signal(value)
  return type(value) == "table" and value.__type == Signal.__type
end

function M.mt:__call(...)
  return new(...)
end

---@overload fun(initial_value: any): Signal
local module = setmetatable(M, M.mt)
return module
