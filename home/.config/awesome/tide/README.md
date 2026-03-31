# Tide 🌙🌊

A reactive signal-based UI framework for AwesomeWM.

## Overview

Tide provides a declarative, reactive widget system inspired by modern JavaScript frameworks like [Preact Signals](https://preactjs.com/guide/v10/signals/) and [SolidJS](https://docs.solidjs.com/concepts/signals), built on top of AwesomeWM in Lua.

This lets you write reactive widgets directly within Lua, without needing to worry about manual state management for most of your UI code.

## Installation

Tide is designed to be used as part of an AwesomeWM configuration. Place the `tide` directory in your AwesomeWM config path.

## Quick Start

```lua
local tide = require("tide")
local signal = tide.signal
local computed = tide.signal.computed
local Container = tide.widget.Container
local Text = tide.widget.Text

-- Create a signal
local count = signal(0)

-- Create a reactive widget
local widget = Container {
  bg = computed(function()
    return count:get() > 5 and "#ff0000" or "#00ff00"
  end),

  Text {
    text = computed(function()
      return "Count: " .. count:get()
    end)
  }
}

-- Update the signal (UI updates automatically)
count:set(10)
```

## Signals

Tide provides a fully custom declarative Signal API. The signal primitives `signal()`, `computed(fn)`, and `effect(fn)` automatically track their dependencies within their tracking scopes, making them fully reactive without any need for manual dependency tracking.

### Basic Signals

```lua
local signal = tide.signal

local name = signal("World")
print(name:get())  -- "World"

name:set("Tide")
print(name:get())  -- "Tide"
```

### Computed Signals

Computed signals derive values from other signals and automatically update when dependencies change:

```lua
local signal = tide.signal
local computed = tide.signal.computed

local first_name = signal("John")
local last_name = signal("Doe")

local full_name = computed(function()
  return first_name:get() .. " " .. last_name:get()
end)

print(full_name:get())  -- "John Doe"

first_name:set("Jane")
print(full_name:get())  -- "Jane Doe"
```

### Effects

Effects are functions that run whenever their signal dependencies change:

```lua
local effect = tide.signal.effect

effect(function()
  print("Count changed to:", count:get())
end)
```

### Property Binding

Bind to AwesomeWM object properties:

```lua
local watch = tide.signal.watch

-- Bind to a tag's selected state
local tag = screen.primary.tags[1]
local tag_selected = watch(tag, "selected")
```

## Widgets

### Primitive Widgets

```lua
local Container = tide.widget.Container
local Text = tide.widget.Text
local Flexible = tide.widget.Flexible

Container {
  padding = 10,
  bg = "#ff0000",
  radius = 8,

  Text { text = "Hello" }
}

Text {
  text = "Hello World",
  color = "#ffffff",
  font = "Inter 12"
}

Flexible {
  grow = 1,
  shrink = 1,
  Text { text = "Flexible content" }
}
```

### Layouts

```lua
local Container = tide.widget.Container
local Text = tide.widget.Text
local Flexible = tide.widget.Flexible
local Row = tide.widget.Row
local Column = tide.widget.Column

Row {
  spacing = 10,
  justify_content = "center",

  Text { text = "Item 1" },
  Text { text = "Item 2" },
  Flexible { Text { text = "Flexible" } }
}

Column {
  spacing = 5,

  Text { text = "Row 1" },
  Text { text = "Row 2" }
}
```

## Flow Control

### For Component

Render lists reactively:

```lua
local signal = tide.signal
local For = tide.flow.For
local Column = tide.widget.Column
local Text = tide.widget.Text

local items = signal({"Apple", "Banana", "Cherry"})

local list = Column {
  For {
    each = items,
    function(item, index)
      return Text { text = item }
    end
  }
}

-- Update the list
items:set({"Apple", "Banana", "Cherry", "Date"})
```

## Windows and Popups

```lua
local Window = tide.Window
local Container = tide.widget.Container
local Text = tide.widget.Text

-- Create a popup
local popup = Window {
  window = awful.popup,
  visible = false,
  ontop = true,

  Container {
    padding = 20,
    Text { text = "Popup content" }
  }
}

-- Show/hide
popup.visible = true
```

## API Reference

### Signal Module

```lua
local signal = tide.signal
local computed = tide.signal.computed
local effect = tide.signal.effect
local batch = tide.signal.batch
local track = tide.signal.track
local untracked = tide.signal.untracked
local watch = tide.signal.watch
```

- `signal(initial_value)` - Create a new signal
- `signal.computed(fn)` - Create a computed signal
- `signal.effect(fn)` - Create an effect
- `signal.batch(fn)` - Batch multiple signal updates
- `signal.track(signal)` - Manually track a signal dependency within an effect
- `signal.untracked(fn)` - Run function without tracking
- `signal.watch(object, property)` - Bind to object property

### Core

- `tide.Widget(args)` - Widget constructor with reactive support
- `tide.Window(args)` - Window base
- `tide.Notification(args)` - Notification wrapper for naughty.layout.box

### Widget Module

- `tide.widget.Container` - Single-child container with styling
- `tide.widget.Text` - Enhanced text widget
- `tide.widget.Flexible` - Flex container child
- `tide.widget.Row` - Horizontal flex layout
- `tide.widget.Column` - Vertical flex layout
- `tide.widget.Grid` - Grid layout
- `tide.widget.Stack` - Stack layout
- `tide.widget.Center` - Centering container
- `tide.widget.ClientIcon` - Client icon widget
- `tide.widget.Image` - Image widget
- `tide.widget.ProgressBar` - Progress bar
- `tide.widget.Systray` - System tray
- `tide.widget.TextClock` - Text clock

### Flow Control

- `tide.flow.For` - Render lists reactively
