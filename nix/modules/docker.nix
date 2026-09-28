{ ... }:
{
  virtualisation.docker.enable = true;

  users.users.miika.extraGroups = [ "docker" ];
}
