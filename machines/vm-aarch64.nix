{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware/vm-aarch64.nix
    ./shared.nix
  ];

  virtualisation.vmware.guest.enable = true;

  hardware.graphics = {
    enable = true;
  };

  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "vmwgfx";
  };

  # Allow Zed to use emulated GPU if hardware acceleration doesn't work
  environment.sessionVariables = {
    ZED_ALLOW_EMULATED_GPU = 1;
  };
}
