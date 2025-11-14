{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./hyprpaper.nix
    ./wofi.nix
  ];

  home.packages = with pkgs; [
    niri # wayland compositor
    wl-clipboard # clipboard manager
    hyprpicker # color picker
    pamixer # pulseaudio mixer
    playerctl # media player control
    viu # cli image viewer
    swww # wallpaper
  ];
}
