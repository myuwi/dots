local helpers = require("helpers")

-- Apps to run on startup
local start_cmds = {
  "/usr/lib/xfce-polkit/xfce-polkit",
  os.getenv("HOME") .. "/.screenlayout/default.sh",
  "picom --legacy-backends",
  "openrazer-daemon",
  "solaar -w hide",
  "fcitx5",
  "flameshot",
  "discord",
}

for _, cmd in ipairs(start_cmds) do
  helpers.run.once(cmd)
end
