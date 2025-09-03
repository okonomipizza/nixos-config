{ pkgs, inputs, ... }:

{
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  
  # Since we're using zsh as our shell
  programs.zsh.enable = true;

  users.users.okonomipizza = {
    isNormalUser = true;
    home = "/home/okonomipizza";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
