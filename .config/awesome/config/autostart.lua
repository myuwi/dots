local helpers = require("helpers")

local home_dir = os.getenv("HOME")

-- Commands to run on startup
local start_cmds = {
  "/usr/lib/xfce-polkit/xfce-polkit",
  home_dir .. "/.dots/.screenlayout/default.sh",
  "picom --legacy-backends",
  "solaar -w hide",
  "fcitx5",
  "vencord-desktop",
}

for _, cmd in ipairs(start_cmds) do
  helpers.run.once(cmd)
end
