{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware/vm-aarch64.nix
    ./vm-shared.nix
  ];

  networking.interfaces.enp2s0.useDHCP = true;

  virtualisation.vmware.guest.enable = true;

  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
  };

  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "vmwgfx";
  };
}
