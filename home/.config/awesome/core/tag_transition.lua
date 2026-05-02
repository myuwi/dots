local awful = require("awful")

-- TODO: Clean up _WM_TRANSITION after transition is done

local M = {}

local TRANSITION_PROP = "_WM_TRANSITION"

local function set_transition(clients, value)
  for _, c in ipairs(clients) do
    if c.valid then
      c:set_xproperty(TRANSITION_PROP, value)
    end
  end
end

local function apply_view_only_transition(tag)
  if not tag then
    return
  end

  local screen = tag.screen
  local prev_tag = screen and screen.selected_tag

  if not prev_tag or prev_tag == tag then
    return
  end

  local direction = tag.index < prev_tag.index and "left" or "right"
  local opposite = direction == "left" and "right" or "left"

  set_transition(tag:clients(), "workspace-" .. direction)
  set_transition(prev_tag:clients(), "workspace-" .. opposite)
end

local function get_relative_tag(screen, step)
  local s = screen or awful.screen.focused()
  local tags = s and s.tags or nil
  local current = s and s.selected_tag or nil

  if not tags or #tags == 0 or not current then
    return nil
  end

  local idx = current.index
  local total = #tags

  for _ = 1, total do
    idx = ((idx - 1 + step) % total) + 1
    local tag = tags[idx]
    if tag and tag.activated ~= false then
      return tag
    end
  end

  return nil
end

function M.view_only(tag)
  if not tag then
    return
  end

  apply_view_only_transition(tag)
  tag:view_only()
end

function M.view_next(screen)
  M.view_only(get_relative_tag(screen, 1))
end

function M.view_prev(screen)
  M.view_only(get_relative_tag(screen, -1))
end

function M.view_toggle(tag)
  awful.tag.viewtoggle(tag)
end

function M.move_to_tag(c, tag)
  if not c or not c.valid or not tag then
    return
  end

  local source_tag = c.screen and c.screen.selected_tag

  if source_tag and source_tag ~= tag and c:isvisible() then
    local move_direction = tag.index < source_tag.index and "left" or "right"
    c:set_xproperty(TRANSITION_PROP, "workspace-" .. move_direction)
  end

  c:move_to_tag(tag)
end

return M
