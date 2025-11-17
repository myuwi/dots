local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Container = require("ui.widgets").Container
local Column = require("ui.widgets").Column
local Row = require("ui.widgets").Row
local Grid = require("ui.widgets").Grid
local Text = require("ui.widgets").Text
local Icon = require("ui.components.icon")

local signal = require("ui.core.signal")
local computed = require("ui.core.signal.computed")

local tbl = require("helpers.table")

local function StyledIcon(args)
  local hovered = signal(false)

  return Container {
    padding = dpi(6),
    radius = beautiful.corner_radius,
    bg = computed(function()
      return hovered:get() and beautiful.window_switcher_hover or nil
    end),
    border_width = 1,
    border_color = computed(function()
      return hovered:get() and beautiful.border_hover or beautiful.colors.transparent
    end),

    on_mouse_enter = function()
      hovered:set(true)
    end,
    on_mouse_leave = function()
      hovered:set(false)
    end,
    on_click = args.on_click,

    Icon {
      size = dpi(16),
      args[1],
    },
  }
end

local function StyledGrid(args)
  return Grid {
    column_count = args.column_count,
    spacing = beautiful.calendar_spacing,
    minimum_row_height = beautiful.calendar_cell_size,
    minimum_column_width = beautiful.calendar_cell_size,
    homogenous = true,
    args[1],
  }
end

local function Cell(args)
  return Text {
    color = args.color,
    halign = "center",
    valign = "center",
    args[1],
  }
end

local function create_weekday_name_cell(weekday_name)
  return Cell {
    color = beautiful.calendar_weekday,
    weekday_name:sub(1, 2),
  }
end

local function create_week_number_cell(day)
  return Cell {
    color = beautiful.calendar_weeknumber,
    day,
  }
end

local function create_day_cell(day)
  return Cell { day }
end

local function create_current_day_cell(day)
  return Container {
    bg = beautiful.calendar_bg_current,
    radius = dpi(4),

    Cell {
      color = beautiful.calendar_fg_current,
      day,
    },
  }
end

local function create_outside_day_cell(day)
  return Cell {
    color = beautiful.calendar_day_other,
    day,
  }
end

local weekday_names = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }

local function calendar(_args)
  local current_date = signal(os.date("*t"))
  local viewed_month =
    signal(os.date("*t", os.time({ year = current_date:get().year, month = current_date:get().month, day = 1 })))

  local function init()
    current_date:set(os.date("*t"))
    viewed_month:set(
      os.date("*t", os.time({ year = current_date:get().year, month = current_date:get().month, day = 1 }))
    )
  end

  local function next_month()
    viewed_month:set(
      os.date("*t", os.time({ year = viewed_month:get().year, month = viewed_month:get().month + 1, day = 1 }))
    )
  end

  local function prev_month()
    viewed_month:set(
      os.date("*t", os.time({ year = viewed_month:get().year, month = viewed_month:get().month - 1, day = 1 }))
    )
  end

  local grid_header = StyledGrid {
    column_count = 7,
    tbl.map(weekday_names, create_weekday_name_cell),
  }

  local calendar_day_cells = computed(function()
    local viewed_month = viewed_month:get() ---@diagnostic disable-line: redefined-local
    local current_date = current_date:get() ---@diagnostic disable-line: redefined-local

    local first_day = os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month, day = 1 }))
    local days_in_month =
      os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month + 1, day = 0 })).day
    local days_in_last_month =
      os.date("*t", os.time({ year = viewed_month.year, month = viewed_month.month, day = 0 })).day

    local days_before = (first_day.wday - 2) % 7
    local days_after = (7 - (days_before + days_in_month) % 7) % 7

    local children = {}

    for i = days_in_last_month - days_before + 1, days_in_last_month do
      table.insert(children, create_outside_day_cell(tostring(i)))
    end

    for i = 1, days_in_month do
      if
        i == current_date.day
        and viewed_month.month == current_date.month
        and viewed_month.year == current_date.year
      then
        table.insert(children, create_current_day_cell(tostring(i)))
      else
        table.insert(children, create_day_cell(tostring(i)))
      end
    end

    for i = 1, days_after do
      table.insert(children, create_outside_day_cell(tostring(i)))
    end

    return children
  end)

  local grid = StyledGrid {
    column_count = 7,
    calendar_day_cells,
  }

  local week_numbers = StyledGrid {
    column_count = 1,
    computed(function()
      local children = {}

      local num_weeks = math.ceil(#calendar_day_cells:get() / 7)

      for i = 0, num_weeks - 1 do
        local week_num =
          os.date("%V", os.time({ year = viewed_month:get().year, month = viewed_month:get().month, day = 1 + i * 7 })) --[[@as string]]

        -- Remove leading zeros
        week_num = week_num:gsub("0*", "", 1)

        table.insert(children, create_week_number_cell(week_num))
      end

      return children
    end),
  }

  local header_text = computed(function()
    return os.date("%B %Y", os.time(viewed_month:get()))
  end)

  local widget = Container {
    padding = dpi(6),
    on_wheel_up = prev_month,
    on_wheel_down = next_month,

    Column {
      spacing = beautiful.calendar_spacing,

      Row {
        justify_content = "space-between",
        spacing = beautiful.calendar_spacing,

        StyledIcon { "chevron-left", on_click = prev_month },
        Text {
          halign = "center",
          header_text,
        },
        StyledIcon { "chevron-right", on_click = next_month },
      },
      Column {
        spacing = beautiful.calendar_spacing,
        Container {
          padding = { left = beautiful.calendar_cell_size + beautiful.calendar_spacing },
          grid_header,
        },
        Row {
          spacing = beautiful.calendar_spacing,
          week_numbers,
          grid,
        },
      },
    },
  }

  widget.reset = init

  return widget
end

return calendar
