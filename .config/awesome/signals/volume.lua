local awful = require("awful")

local volume_last --- @type integer?
local muted_last --- @type boolean?

local daemon_script = [[
bash -c "
  LANG=C pactl subscribe 2> /dev/null |
  grep --line-buffered \"Event 'change' on sink #\" |
  while read; do
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed -e 's/Volume: //';
  done
"]]

awful.spawn.easy_async(string.format("pkill -f -U %s %s", os.getenv("USER"), "'^pactl subscribe'"), function()
  awful.spawn.with_line_callback(daemon_script, {
    stdout = function(line)
      local volume_str = line:match("([%d.]+)")
      local muted_str = line:match("MUTED")

      local volume = math.floor(tonumber(volume_str) * 100)
      local muted = muted_str ~= nil

      if volume ~= volume_last or muted ~= muted_last then
        awesome.emit_signal("volume_change", {
          volume = volume,
          muted = muted,
        })
        volume_last = volume
        muted_last = muted
      end
    end,
  })
end)
