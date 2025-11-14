{
  pkgs,
  inputs,
  ...
}: {
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = ["/share/fish"];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Enable Electron app wayland mode
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.okonomipizza = {
    isNormalUser = true;
    home = "/home/okonomipizza";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };
}
