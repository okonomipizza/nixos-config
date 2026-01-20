{
  config,
  pkgs,
  lib,
  currentSystem,
  currentSystemName,
  ...
}: {
    imports = [./shared.nix];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  boot.loader.systemd-boot.consoleMode = "0";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behavior.
  networking.useDHCP = false;
  networking = {
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };

  networking.networkmanager.enable = lib.mkForce true;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Open ports in the firewall.
  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}
