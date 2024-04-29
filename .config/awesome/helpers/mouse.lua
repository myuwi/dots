local _M = {}

-- https://github.com/awesomeWM/awesome/issues/3806
function _M.remove_global_mousebinding(button)
  local root_btns = root._buttons()

  for _, v1 in ipairs(button) do
    for i, v2 in ipairs(root_btns) do
      if v1 == v2 then
        table.remove(root_btns, i)
      end
    end
  end

  root._buttons(root_btns)
end

function _M.remove_global_mousebindings(buttons)
  for _, v in ipairs(buttons) do
    _M.remove_global_mousebinding(v)
  end
end

return _M
