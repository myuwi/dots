local awful = require("awful")

local volume_last --- @type integer?
local muted_last --- @type boolean?

local script = [[
bash -c "
  LANG=C pactl subscribe 2> /dev/null |
  grep --line-buffered \"Event 'change' on sink #\" |
  while read; do
    amixer sget Master | grep 'Right:';
  done
"]]

awful.spawn.easy_async(string.format("pkill -f -U %s %s", os.getenv("USER"), "'^pactl subscribe'"), function()
  awful.spawn.with_line_callback(script, {
    stdout = function(stdout)
      local volume_str = stdout:match("%[(.-)%%]")
      local muted_str = stdout:match("%[(%w-)%]")

      local volume = tonumber(volume_str)
      local muted = muted_str == "off"

      if volume ~= volume_last or muted ~= muted_last then
        if volume_last or muted_last then
          awesome.emit_signal("volume_change", volume, muted)
        end
        volume_last = volume
        muted_last = muted
      end
    end,
  })
end)
