{ ... }:
{
  virtualisation.docker.enable = true;

  users.users.miika.extraGroups = [ "docker" ];

  networking.firewall.trustedInterfaces = [
    "docker0"
    "br-+"
  ];
}
