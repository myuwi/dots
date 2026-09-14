{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.enableAskPassword = true;
  programs.ssh.askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";
  systemd.packages = [ pkgs.gcr_4 ];
  systemd.user.sockets.gcr-ssh-agent.wantedBy = [ "sockets.target" ];
  systemd.user.services.gcr-ssh-agent.serviceConfig.ExecStart = [
    ""
    "${pkgs.gcr_4}/libexec/gcr-ssh-agent --base-dir %t/gcr -- -t 15m"
  ];
}
