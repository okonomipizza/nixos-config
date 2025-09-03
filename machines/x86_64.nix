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
}
