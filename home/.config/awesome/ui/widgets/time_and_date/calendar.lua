local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local helpers = require("helpers")

local function create_grid(cols)
  return wibox.widget({
    column_count = cols,
    spacing = beautiful.calendar_spacing,
    minimum_row_height = beautiful.calendar_cell_size,
    minimum_column_width = beautiful.calendar_cell_size,
    homogenous = true,
    layout = wibox.layout.grid,
  })
end

local function create_cell(markup)
  return wibox.widget({
    markup = markup,
    halign = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })
end

local function weekday_cell(day)
  return create_cell(helpers.ui.colorize_text(day, beautiful.calendar_weekday))
end

local function week_number_cell(day)
  return create_cell(helpers.ui.colorize_text(day, beautiful.calendar_weeknumber))
end

local function calendar_cell(day)
  return create_cell(day)
end

local function calendar_current_cell(day)
  return {
    create_cell(helpers.ui.colorize_text(day, beautiful.calendar_fg_current)),
    bg = beautiful.calendar_bg_current,
    shape = helpers.shape.rounded_rect(4),
    widget = wibox.container.background,
  }
end

local function calendar_other_month_cell(day)
  return create_cell(helpers.ui.colorize_text(day, beautiful.calendar_day_other))
end

local function calendar()
  local title = wibox.widget({
    forced_height = beautiful.calendar_cell_size,
    widget = wibox.widget.textbox,
  })

  local grid_header = create_grid(7)
  local grid = create_grid(7)
  local week_numbers = create_grid(1)

  for _, v in ipairs({ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }) do
    grid_header:add(weekday_cell(v:sub(1, 2)))
  end

  local function update_calendar(viewed_month, current_date)
    title.text = os.date("%B %Y", os.time(viewed_month))

    grid:reset()
    week_numbers:reset()

    local first_day = os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month, day = 1 }))
    local days_in_month =
      os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month + 1, day = 0 })).day
    local days_in_last_month =
      os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month, day = 0 })).day

    local days_to_add_before = (first_day.wday - 2) % 7
    local days_to_add_after = (7 - (days_to_add_before + days_in_month) % 7) % 7

    for i = days_in_last_month - days_to_add_before + 1, days_in_last_month do
      grid:add(calendar_other_month_cell(tostring(i)))
    end

    for i = 1, days_in_month do
      if
        i == current_date.day
        and viewed_month.month == current_date.month
        and viewed_month.year == current_date.year
      then
        grid:add(calendar_current_cell(tostring(i)))
      else
        grid:add(calendar_cell(tostring(i)))
      end
    end

    for i = 1, days_to_add_after do
      grid:add(calendar_other_month_cell(tostring(i)))
    end

    local num_weeks = math.ceil((days_in_month + days_to_add_before) / 7)

    for i = 0, num_weeks - 1 do
      local week_num =
        os.date("%V", os.time({ year = first_day.year, month = first_day.month, day = first_day.day + i * 7 })) --[[@as string]]

      -- Remove leading zeros
      week_num = week_num:gsub("0*", "", 1)

      week_numbers:add(week_number_cell(week_num))
    end
  end

  local today = os.date("*t")
  local viewed_month = os.date("*t", os.time({ year = today.year, month = today.month, day = 1 }))

  update_calendar(viewed_month, today)

  local widget = wibox.widget({
    {
      {
        title,
        halign = "center",
        widget = wibox.container.place,
      },
      {
        {
          {
            week_numbers,
            top = beautiful.calendar_cell_size + beautiful.calendar_spacing,
            widget = wibox.container.margin,
          },
          {
            grid_header,
            grid,
            spacing = beautiful.calendar_spacing,
            layout = wibox.layout.fixed.vertical,
          },
          spacing = beautiful.calendar_spacing,
          layout = wibox.layout.fixed.horizontal,
        },
        halign = "center",
        widget = wibox.container.place,
      },
      spacing = beautiful.calendar_spacing,
      layout = wibox.layout.fixed.vertical,
    },
    margins = dpi(6),
    widget = wibox.container.margin,
  })

  widget.buttons = {
    awful.button({}, 4, function()
      viewed_month = os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month - 1, day = 1 }))
      update_calendar(viewed_month, today)
    end),
    awful.button({}, 5, function()
      viewed_month = os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month + 1, day = 1 }))
      update_calendar(viewed_month, today)
    end),
  }

  -- TODO: Automatically update "today" date when date changes?
  function widget:update()
    today = os.date("*t")
    update_calendar(viewed_month, today)
  end

  function widget:reset()
    today = os.date("*t")
    viewed_month = os.date("*t", os.time({ year = today.year, month = today.month, day = 1 }))
    update_calendar(viewed_month, today)
  end

  return widget
end

return calendar
