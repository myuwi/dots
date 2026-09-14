{ ... }:
{
  boot.initrd.systemd.enable = true;
  boot.tmp.cleanOnBoot = true;
  boot.blacklistedKernelModules = [
    "pcspkr"
    "snd_pcsp"
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fi";
  services.xserver.xkb.layout = "fi";
}
