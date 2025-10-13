{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware/x86_64.nix
    ./shared.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
  };
}
