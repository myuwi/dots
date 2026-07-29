#!/usr/bin/env nu
# Set mouse_accel_speed from the focused app's appid.
# For -0.1 == 0.9x, set mouse_accel_profile=1 (Flat).

def speed-for [appid: string]: nothing -> string {
  match $appid {
    "osu!" => "-0.225"
    _ => "0.0"
  }
}

def main [] {
  mut last_speed: oneof<string, nothing> = null

  # outer loop reconnects when the stream drops (e.g. compositor restart)
  loop {
    for line in (mmsg watch focusing-client | lines) {
      let appid = $line
      | from json
      | get appid?
      | default ""

      let speed = speed-for $appid

      if $speed != $last_speed {
        let notify = $last_speed != null or $speed != '0.0'
        $last_speed = $speed

        mmsg dispatch $"setoption,mouse_accel_speed,($speed)" | ignore

        if $notify {
          try {
            qs ipc call -- osd show mouse "Mouse accel" $speed -1 | ignore
          }
        }
      }
    }
    $last_speed = null
    sleep 1sec
  }
}
