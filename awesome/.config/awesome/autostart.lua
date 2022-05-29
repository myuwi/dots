local awful = require("awful")

-- Apps to run on startup
local start_apps = {
  "picom",
  "openrazer-daemon",
  "fcitx5",
  "flameshot",
  "discord",
  "/usr/lib/xfce-polkit/xfce-polkit",
}

-- Run if not already running
local spawn_once = function(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  if cmd:find("/") then
    findme = cmd:match("([%w-]+)$")
  end
  if findme:len() > 15 then
    findme = findme:sub(1, 15)
  end
  awful.spawn.with_shell(string.format("pgrep -u $USER -ix %s > /dev/null || (%s)", findme, cmd))
end

for _, app in ipairs(start_apps) do
  spawn_once(app)
end
