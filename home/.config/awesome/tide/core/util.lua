local Util = {}

function Util.wrap(w, name, fn)
  local old_fn = w[name]

  if old_fn then
    w[name] = function(_, ...)
      old_fn(w, fn(w, ...))
    end
  else
    w[name] = function(_, ...)
      fn(w, ...)
    end
  end
end

return Util
