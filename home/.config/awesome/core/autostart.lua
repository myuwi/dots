local helpers = require("helpers")

-- Commands to run on startup
local start_cmds = {
  "/usr/lib/xfce-polkit/xfce-polkit",
  "disp home",
  "picom",
  "solaar -w hide",
  "fcitx5",
  "vesktop",
  "xset r rate 400",
}

for _, cmd in ipairs(start_cmds) do
  helpers.run.once(cmd)
end
