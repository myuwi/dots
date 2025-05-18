-- TODO: Reactive bindings?

local function bind(emitter, property, callback)
  emitter:connect_signal("property::" .. property, function(self)
    callback(self[property])
  end)
end

return bind
