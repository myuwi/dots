local helpers = require("helpers")

local home_dir = os.getenv("HOME")

-- Commands to run on startup
local start_cmds = {
  "/usr/lib/xfce-polkit/xfce-polkit",
  home_dir .. "/.dots/.screenlayout/default.sh",
  "picom",
  "solaar -w hide",
  "fcitx5",
  "vesktop",
}

for _, cmd in ipairs(start_cmds) do
  helpers.run.once(cmd)
end
