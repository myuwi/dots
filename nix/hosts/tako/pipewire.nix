{ pkgs, ... }:
{
  services.pipewire.extraConfig.pipewire."10-coupled-streams" = {
    "context.modules" = [
      {
        name = "libpipewire-module-loopback";
        args = {
          "audio.position" = [
            "FL"
            "FR"
          ];
          "capture.props" = {
            "media.class" = "Audio/Sink";
            "node.name" = "game_sink";
            "node.description" = "Virtual game sink";
          };
        };
      }
    ];
  };

  services.pipewire.extraConfig.pipewire."20-combine-stream" = {
    "context.modules" = [
      {
        name = "libpipewire-module-combine-stream";
        args = {
          "combine.mode" = "sink";
          "node.name" = "all_connected_sink";
          "node.description" = "All Connected Outputs";
          "combine.props" = {
            "audio.position" = [
              "FL"
              "FR"
            ];
          };
          "stream.rules" = [
            {
              matches = [
                {
                  "node.name" = "~^alsa_output\\..*";
                  "media.class" = "Audio/Sink";
                }
              ];
              actions = {
                "create-stream" = { };
              };
            }
          ];
        };
      }
    ];
  };

  services.pipewire.extraConfig.pipewire."99-input-denoising" = {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        args = {
          "node.description" = "Noise Canceling source";
          "media.name" = "Noise Canceling source";
          "filter.graph" = {
            nodes = [
              {
                type = "ladspa";
                name = "rnnoise";
                plugin = "${pkgs.rnnoise-plugin.ladspa}/lib/ladspa/librnnoise_ladspa.so";
                label = "noise_suppressor_mono";
                control = {
                  "VAD Threshold (%)" = 20.0;
                  "VAD Grace Period (ms)" = 500;
                  "Retroactive VAD Grace (ms)" = 20;
                };
              }
            ];
          };
          "capture.props" = {
            "node.name" = "capture.rnnoise_source";
            "node.passive" = true;
            "audio.rate" = 48000;
            "audio.channels" = 1;
            "audio.position" = [ "MONO" ];
          };
          "playback.props" = {
            "node.name" = "rnnoise_source";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
            "audio.channels" = 1;
            "audio.position" = [ "MONO" ];
          };
        };
      }
    ];
  };
}
