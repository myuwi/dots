{
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_1TB_S626NJ0R170132T";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "2G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = [ "-F" "32" ];
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        root = {
          priority = 2;
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd:1"
                  "noatime"
                ];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd:1"
                  "noatime"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd:1"
                  "noatime"
                ];
              };
              "@swap" = {
                mountpoint = "/swap";
                mountOptions = [ "noatime" ];
                swap.swapfile.size = "8G";
              };
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = [
                  "compress=zstd:1"
                  "noatime"
                ];
              };
              "@snapshots" = {
                mountpoint = "/.snapshots";
                mountOptions = [
                  "compress=zstd:1"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}
