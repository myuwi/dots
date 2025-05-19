local function effect(fn)
  local observer = {
    ---@type table<Signal, fun()>
    dependents = {},
  }

  local function run()
    -- Unsubscribe from previous signals
    for _, unsubscribe in pairs(observer.dependents) do
      unsubscribe()
    end

    -- Reset dependents
    observer.dependents = {}

    -- Track dependencies
    _G.current_signal_observer = {
      register = function(sig)
        if not observer.dependents[sig] then
          observer.dependents[sig] = sig:subscribe(run, false)
        end
      end,
    }

    -- Run closure
    fn()

    _G.current_signal_observer = nil
  end

  run()
end

return effect
