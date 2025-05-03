local helpers = require("helpers")

-- Commands to run on startup
local start_cmds = {
  "/usr/lib/xfce-polkit/xfce-polkit",
  "disp home",
  "picom",
  "solaar -w hide",
  "fcitx5",
  "vesktop",
}

for _, cmd in ipairs(start_cmds) do
  helpers.run.once(cmd)
end
