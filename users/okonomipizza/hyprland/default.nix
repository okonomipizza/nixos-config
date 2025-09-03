{ pkgs, inputs, ... }:
{
  imports = [
    ./settings.nix
    ./key-binds.nix
    ./wofi.nix
    ./dunst.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
  ];

  wayland.windowManager.hyprland.enable = true;

  home.packages = with pkgs; [
    hyprpicker # color picker
    pamixer # pulseaudio mixer
    playerctl # media player control
    wl-clipboard # clipboard manager
  ];


}
